#!/bin/bash

# Force running as sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi


# Add user based on first argument, check if sudo on second
if [ "$2" = "sudo" ]; then
  adduser "$1" --ingroup researchers
  adduser "$1" --ingroup sudo
else
  adduser "$1" --ingroup researchers
fi

# Force user to change password on next log-in
passwd --expire "$1"

# Create a folder for them on the data disk
mkdir -p "/media/data/${1}"
chown -R ${1}:${1} "/media/data/${1}"
chmod -R 755 "/media/data/${1}"


# Also add to slurm system
sacctmgr -i create user $1 defaultaccount=researchers partition=GPU

edquota "$1"
