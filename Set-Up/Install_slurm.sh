# Based on http://rolk.github.io/2015/04/20/slurm-cluster
apt-get install -y grub2

# Limit resources so that not everything can be used when logged in to Computer
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
