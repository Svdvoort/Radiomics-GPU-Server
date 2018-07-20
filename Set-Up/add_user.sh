#!/bin/bash

# Add user based on first argument, check if sudo on second
if [ "$2" = "sudo" ]; then
  adduser "$1"
  adduser "$1" sudo
else
  adduser "$1"
fi
# Check if sudo, then add
