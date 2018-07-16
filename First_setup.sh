#!/bin/bash

# Make folder for all our installation stuff, we will use admin
lsb_release -a
sudo mkdir /home/admin
sudo cp -R ../Radiomics-GPU-Server /home/admin

sudo mkdir /packages
