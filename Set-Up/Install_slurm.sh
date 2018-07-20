#!/bin/bash

# Based on http://rolk.github.io/2015/04/20/slurm-cluster
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

apt-get install -y grub2

#Limit resourcs so that not everything can be used when logged in to Computer
apt-get install -y cgroup-bin
sed -i 's,\(^GRUB_CMDLINE_LINUX_DEFAULT\)=\"\(.*\)",\1=\"\2 cgroup_enable=memory swapaccount=1\",' /etc/default/grub
update-grub

sh -c "cat > /etc/cgconfig.conf" <<EOF
group interactive {
   cpu {
# length of the reference period is 1 second (across all cores)
      cpu.cfs_period_us = "1000000";
# allow this group to only use total of 0.25 cpusecond (across all cores)
# i.e. throttle the group to half of a single CPU
      cpu.cfs_quota_us = "500000";
   }
   memory {
# 2 GiB limit for interactive users
      memory.limit_in_bytes = "2G";
      memory.memsw.limit_in_bytes = "2G";
   }
}
EOF

sh -c "cat >> /etc/init/cgroup-config.conf" <<EOF
description "Setup initial cgroups"
task
start on started cgroup-lite
script
/usr/sbin/cgconfigparser -l /etc/cgconfig.conf
end script
EOF

sh -c "cat >> /etc/cgrules.conf" <<EOF
root             cpu,memory    /
slurm            cpu,memory    /
*                cpu,memory    /interactive
EOF

apt-get install -y libpam-cgroup
sh -c "cat >> /etc/pam.d/common-session" <<EOF
session optional        pam_cgroup.so
EOF

# Insatll mysql
apt-get install -y pwgen

DB_ROOT_PASS=$(pwgen -s 16 1)
DB_SLURM_PASS=$(pwgen -s 16 1)

apt-get install -y mysql-server
sed -i 's/^\(bind-address[\ \t]*\)=\(.*\)/\1= 127.0.0.1/' /etc/mysql/my.cnf

touch ~root/.my.cnf
chown root:root ~root/.my.cnf
chmod 700 ~root/.my.cnf

sh -c "cat > ~root/.my.cnf" <<EOF
[client]
user=root
password=$DB_ROOT_PASS
EOF

mysql --user=root --password="" <<EOF
update mysql.user set password=password('$DB_ROOT_PASS') where user='root';
delete from mysql.user where user='root' and host not in ('localhost', '127.0.0.1', '::1');
delete from mysql.user where user='';
flush privileges;
EOF

HOME=~root mysql <<EOF
create database slurm_acct_db;
create user 'slurm'@'localhost';
set password for 'slurm'@'localhost' = password('$DB_SLURM_PASS');
grant usage on *.* to 'slurm'@'localhost';
grant all privileges on slurm_acct_db.* to 'slurm'@'localhost';
flush privileges;
EOF


# Install munge, required for slurm
apt-get install -y munge
/usr/sbin/create-munge-key
sed -i '/# OPTIONS/aOPTIONS="--syslog"' /etc/default/munge

Install slurm
apt-get install -y slurmdbd slurm-wlm-basic-plugins slurm-wlm slurm-wlm-torque slurmctld slurmd

touch /etc/slurm-llnl/slurmdbd.conf
chown slurm:slurm /etc/slurm-llnl/slurmdbd.conf
chmod 660 /etc/slurm-llnl/slurmdbd.conf

sh -c "cat > /etc/slurm-llnl/slurmdbd.conf" <<EOF
# logging level
ArchiveEvents=no
ArchiveJobs=no
ArchiveSteps=no
ArchiveSuspend=no

# service
DbdHost=localhost
SlurmUser=slurm
AuthType=auth/munge

# logging; remove this to use syslog
LogFile=/var/log/slurm-llnl/slurmdbd.log

# database backend
StoragePass=$DB_SLURM_PASS
StorageUser=slurm
StorageType=accounting_storage/mysql
StorageLoc=slurm_acct_db
EOF


touch /etc/slurm-llnl/slurm.conf
chown slurm:slurm /etc/slurm-llnl/slurm.conf
chmod 664 /etc/slurm-llnl/slurm.conf

sh -c "cat > /etc/slurm-llnl/slurm.conf" <<EOF
# identification
ClusterName=$(hostname -s)
ControlMachine=$(hostname -s)

# authentication
AuthType=auth/munge
CacheGroups=0
CryptoType=crypto/munge

# service
# proctrack/cgroup controls the freezer cgroup
SlurmUser=slurm
SlurmctldPort=6817
SlurmdPort=6818
SlurmdSpoolDir=/var/lib/slurm-llnl/slurmd
StateSaveLocation=/var/lib/slurm-llnl/slurmctld
SlurmctldPidFile=/var/run/slurmctld.pid
SlurmdPidFile=/var/run/slurmd%n.pid
SwitchType=switch/none
ProctrackType=proctrack/cgroup
MpiDefault=none
RebootProgram=/sbin/reboot

# get back on track as soon as possible
ReturnToService=2

# logging
SlurmctldLogFile=/var/log/slurm-llnl/slurmctld.log
SlurmdLogFile=/var/log/slurm-llnl/slurmd.log

# accounting
AccountingStorageType=accounting_storage/slurmdbd
AccountingStorageEnforce=limits

# checkpointing
#CheckpointType=checkpoint/blcr

# scheduling
SchedulerType=sched/backfill
PriorityType=priority/multifactor
PriorityDecayHalfLife=3-0
PriorityMaxAge=7-0
PriorityFavorSmall=YES
PriorityWeightAge=1000
PriorityWeightFairshare=0
PriorityWeightJobSize=125
PriorityWeightPartition=1000
PriorityWeightQOS=0
PreemptMode=suspend,gang
PreemptType=preempt/partition_prio

# wait 30 minutes before assuming that a node is dead
SlurmdTimeout=1800

# core and memory is the scheduling units
# task/cgroup controls cpuset, memory and devices cgroups
SelectType=select/cons_res
SelectTypeParameters=CR_Core_Memory,CR_CORE_DEFAULT_DIST_BLOCK
TaskPlugin=task/affinity,task/cgroup

# computing nodes
NodeName=$(hostname -s) RealMemory=$(grep "^MemTotal:" /proc/meminfo | awk '{print int($2/1024)}') Sockets=$(grep "^physical id" /proc/cpuinfo | sort -uf | wc -l) CoresPerSocket=$(grep "^siblings" /proc/cpuinfo | head -n 1 | awk '{print $3}') ThreadsPerCore=1 State=UNKNOWN

# partitions
PartitionName=DEFAULT  Nodes=$(hostname -s) Shared=FORCE:1 MaxTime=INFINITE State=UP
PartitionName=GPU  Priority=10 Default=YES
EOF

touch /etc/slurm-llnl/cgroup.conf
chown slurm:slurm /etc/slurm-llnl/cgroup.conf
chmod 664 /etc/slurm-llnl/cgroup.conf

sh -c "cat > /etc/slurm-llnl/cgroup.conf" <<EOF
CgroupMountpoint=/sys/fs/cgroup
CgroupAutomount=no
CgroupReleaseAgentDir="/etc/slurm-llnl/cgroup"
ConstrainCores=yes
#TaskAffinity=yes
ConstrainRAMSpace=yes
EOF

unset DB_ROOT_PASS
unset DB_SLURM_PASS


# Now we set-up the cluster
# This needs to be done after rebooting!
sacctmgr -i add cluster $(hostname -s)
sacctmgr -i add account researchers Description="Researcher" Organization="Radiomics"
