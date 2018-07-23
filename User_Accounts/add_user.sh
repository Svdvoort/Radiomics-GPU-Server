#!/bin/bash

# Force running as sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi


# Add user based on first argument, check if sudo on second
if [ "$2" = "sudo" ]; then
  adduser "$1"
  adduser "$1" sudo
else
  adduser "$1"
fi

# Force user to change password on next log-in
#passwd --expire "$1"

# Create a folder for them on the data disk
mkdir /media/data/$1
chmod -r 744 /media/data/$1


# Also add to slurm system
sacctmgr -i create user $1 defaultaccount=researchers partition=GPU
