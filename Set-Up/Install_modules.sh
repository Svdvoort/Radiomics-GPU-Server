#!/bin/bash

sudo mkdir /home/admin/Modules
sudo git clone --branch v4.1.3 --depth 1 https://github.com/cea-hpc/modules.git /home/admin/Modules

sudo apt-get install -y make sed grep autoconf automake autopoint gcc tcl-dev dejagnu python
cd /home/admin/Modules
sudo ./configure --prefix=/usr/share/Modules --modulefilesdir=/etc/modulefiles
sudo make
sudo make install
sudo make distclean

sudo ln -s /usr/share/Modules/init/profile.sh /etc/profile.d/modules.sh
sudo ln -s /user/share/Modules/init/profile.csh /etc/profile.d/modules.csh
