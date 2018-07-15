#!/bin/bash

mkdir /home/admin/temp_packages/
mkdir /home/admin/temp_packages/python_2_7_15

cd /home/admin/temp_packages/python_2_7_15
wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz
tar -xzvf Python-2.7.15.tgz
