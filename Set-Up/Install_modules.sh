#!/bin/bash

git clone --branch v4.1.3 --depth 1 https://github.com/cea-hpc/modules.git /home/admin/Modules
cd /home/admin/Modules

apt-get install make sed grep autoconf automake autopoint gcc tcl-dev dejagnu
