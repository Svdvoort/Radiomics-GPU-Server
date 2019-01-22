#!/bin/bash

# Based on https://www.slothparadise.com/how-to-install-slurm-on-centos-7-cluster/
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

#apt-get install -y mysql-server
#mysql -u root -e "create database slurm_acct_db"
#mysql -u root -e "create user 'slurm'@'localhost';"
#mysql -u root -e "set password for 'slurm'@'localhost' = password('slurmdbpass');"
#mysql -u root -e "grant usage on *.* to 'slurm'@'localhost';"
#mysql -u root -e "grant all privileges on slurm_acct_db.* to 'slurm'@'localhost';"
#mysql -u root -e "flush privileges;"




export MUNGEUSER=991
groupadd -g $MUNGEUSER munge
useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=992
groupadd -g $SLURMUSER slurm
useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

apt-get install -y munge
apt-get install -y rng-tools
rngd -r /dev/urandom

/usr/sbin/create-munge-key -r

systemctl stop munge
ssh root@bigr-nzxt-5 "systemctl stop munge"


dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key
chown -R munge: /etc/munge/ /var/log/munge/
chmod 0700 /etc/munge /var/log/munge
chown munge: /etc/munge/munge.key
chmod 400 /etc/munge/munge.key

# we set up the nodes
scp /etc/munge/munge.key root@bigr-nzxt-5:/etc/munge
ssh root@bigr-nzxt-5 "apt-get install -y munge"
ssh root@bigr-nzxt-5 "chown -R munge: /etc/munge/ /var/log/munge/"
ssh root@bigr-nzxt-5 "chmod 0700 /etc/munge /var/log/munge"
ssh root@bigr-nzxt-5 "chown munge: /etc/munge/munge.key"
ssh root@bigr-nzxt-5 "chmod 400 /etc/munge/munge.key"

ssh root@bigr-nzxt-5 "systemctl enable munge"
ssh root@bigr-nzxt-5 "systemctl start munge"

systemctl enable munge
systemctl start munge

# Install slurm
apt-get install -y slurmdbd slurm-wlm-basic-plugins slurm-wlm slurm-wlm-torque slurmctld slurmd

# Install slurm on nodes
ssh root@bigr-nzxt-5 "apt-get install -y slurmdbd slurm-wlm-basic-plugins slurm-wlm-torque slurmd"

cp ./Templates/slurm.conf /etc/slurm-llnl/slurm.conf
cp ./Templates/cgroup.conf /etc/slurm-llnl/cgroup.conf
cp ./Templates/create_tmp_prolog /etc/slurm-llnl/create_tmp_prolog
cp ./Templates/create_tmp_epilog /etc/slurm-llnl/create_tmp_epilog
cp ./Templates/gres_bigr_nzxt_7.conf /etc/slurm-llnl/gres.conf
#cp ./Templates/slurmdbd.conf /etc/slurm-llnl/slurmdbd.conf
scp /etc/slurm-llnl/slurm.conf root@bigr-nzxt-5:/etc/slurm-llnl/slurm.conf
scp /etc/slurm-llnl/cgroup.conf root@bigr-nzxt-5:/etc/slurm-llnl/cgroup.conf
scp /etc/slurm-llnl/create_tmp_prolog root@bigr-nzxt-5:/etc/slurm-llnl/create_tmp_prolog
scp /etc/slurm-llnl/create_tmp_epilog root@bigr-nzxt-5:/etc/slurm-llnl/create_tmp_epilog
scp ./Templates/gres_bigr_nzxt_5.conf root@bigr-nzxt-5:/etc/slurm-llnl/gres.conf

mkdir -p /var/spool/slurmctld
chown slurm: /var/spool/slurmctld
chmod 755 /var/spool/slurmctld
touch /var/log/slurmctld.log
chown slurm: /var/log/slurmctld.log
touch /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
chown slurm: /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
mkdir -p /var/run/slurm-llnl/
chown slurm: /var/run/slurm-llnl/
chmod 755 /var/run/slurm-llnl/
touch /var/run/slurm-llnl/slurmd.pid
chown slurm: /var/run/slurm-llnl/slurmd.pid
mkdir -p /slurmtmp
chmod 777 /slurmtmp/
chown slurm: /slurmtmp


ssh root@bigr-nzxt-5 "mkdir -p /var/spool/slurmd"
ssh root@bigr-nzxt-5 "chown slurm: /var/spool/slurmd"
ssh root@bigr-nzxt-5 "chmod 755 /var/spool/slurmd"
ssh root@bigr-nzxt-5 "touch /var/log/slurmd.log"
ssh root@bigr-nzxt-5 "chown slurm: /var/log/slurmd.log"
ssh root@bigr-nzxt-5 "mkdir -p /var/run/slurm-llnl/"
ssh root@bigr-nzxt-5 "chown slurm: /var/run/slurm-llnl/"
ssh root@bigr-nzxt-5 "chmod 755 /var/run/slurm-llnl/"
ssh root@bigr-nzxt-5 "mkdir -p /slurmtmp"
ssh root@bigr-nzxt-5 "chmod 777 /slurmtmp/"
ssh root@bigr-nzxt-5 "chown slurm: /slurmtmp"


systemctl enable slurmctld.service
systemctl start slurmctld.service
systemctl status slurmctld.service

ssh root@bigr-nzxt-5 "systemctl enable slurmd.service"
ssh root@bigr-nzxt-5 "systemctl start slurmd.service"
ssh root@bigr-nzxt-5 "systemctl status slurmd.service"

systemctl enable slurmd.service
systemctl start slurmd.service
systemctl status slurmd.service
