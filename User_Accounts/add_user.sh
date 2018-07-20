#!/bin/bash

# Add user based on first argument, check if sudo on second
if [ "$2" = "sudo" ]; then
  adduser "$1"
  adduser "$1" sudo
else
  adduser "$1"
fi
# Also add to slurm system
sacctmgr -i create user $1 defaultaccount=researchers partition=GPU
