#!/bin/bash

mkdir /home/admin/Modules
# We install version 4.1.3
git clone --branch v4.1.3 --depth 1 https://github.com/cea-hpc/modules.git /home/admin/Modules

# Install the required packages
apt-get install -y make sed grep autoconf automake autopoint gcc tcl-dev dejagnu python libffi-dev
cd /home/admin/Modules
./configure --prefix=/usr/share/Modules --modulefilesdir=/etc/modulefiles
make
make install
make distclean

# Make links such that modules is loaded at start-up
ln -s /usr/share/Modules/init/profile.sh /etc/profile.d/modules.sh
ln -s /usr/share/Modules/init/profile.csh /etc/profile.d/modules.csh

# Source them so they're loaded Now
source /etc/profile.d/modules.sh
# Also make sure it's loaded at start-up
echo "source /etc/profile.d/modules.sh" >> /etc/profile
echo "source /etc/profile.d/modules.sh" >> /etc/bash.bashrc

# Ensure modules actually loads
module list
