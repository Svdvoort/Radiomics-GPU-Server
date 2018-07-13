#!/bin/bash

# Make folder for all our installation stuff, we will use admin
mkdir /home/admin
cp -R ../Radiomics-GPU-Server /home/admin
cd /home/admin/Radiomics-GPU-Server
chmod +x Set-Up/Install_modules.sh
