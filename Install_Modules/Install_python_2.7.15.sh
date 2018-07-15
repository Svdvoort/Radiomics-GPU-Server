#!/bin/bash

# Make folder to store temporary files and get source
sudo mkdir /home/admin/temp_packages/
sudo mkdir /home/admin/temp_packages/python_2_7_15


cd /home/admin/temp_packages/python_2_7_15
wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz
tar -xzvf Python-2.7.15.tgz
cd Python-2.7.15

# Configure with the Module folder as target folder
sudo mkdir /packages/python/2.7.15
./configure --prefix=/packages/python/2.7.15 --enable-optimizations
make -j4
sudo make install
