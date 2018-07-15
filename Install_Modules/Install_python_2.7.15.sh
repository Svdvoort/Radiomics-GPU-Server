#!/bin/bash

# Make folder to store temporary files and get source
mkdir /home/admin/temp_packages/
mkdir /home/admin/temp_packages/python_2_7_15


cd /home/admin/temp_packages/python_2_7_15
wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz
tar -xzvf Python-2.7.15.tgz
cd Python-2.7.15

# Configure with the Module folder as target folder
mkdir /packages/python/2.7.15
./configure --prefix=/packages/python/2.7.15
make
make install
