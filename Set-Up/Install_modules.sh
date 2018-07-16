#!/bin/sh

mkdir /home/admin/Modules
git clone --branch v4.1.3 --depth 1 https://github.com/cea-hpc/modules.git /home/admin/Modules

apt-get install -y make sed grep autoconf automake autopoint gcc tcl-dev dejagnu python
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
source /etc/profile.d/modules.csh

# Ensure modules actually loads
module list
