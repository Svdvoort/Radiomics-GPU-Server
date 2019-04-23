#!/bin/bash

# Based on http://rolk.github.io/2015/04/20/slurm-cluster
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Run as the root user!! (NOT SUDO, ROOT USER)
ssh-keygen
ssh-copy-id root@bigr-nzxt-5
ssh-copy-id root@bigr-nzxt-4
