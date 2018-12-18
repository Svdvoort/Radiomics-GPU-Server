#!/bin/bash

# Based on http://rolk.github.io/2015/04/20/slurm-cluster
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

apt-get install -y quota

echo "You need to edit the /etc/fstab file"
echo "add usrquota behind / and /media/data"
echo "Then reboot and run this script again"

quotacheck -cum /
quotacheck -cum /media/data

quotaon /
quotaon /media/data
