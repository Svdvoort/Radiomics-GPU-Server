#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

openssl_URL='https://www.openssl.org/source/openssl-1.0.2o.tar.gz'
mkdir -p /home/admin/temp_packages/openssl-1.0.2
mkdir -p /packages/openssl1.0/
cd /home/admin/temp_packages/openssl-1.0.2
wget $openssl_URL | tar -xzf -

cd openssl-1.0.2o
./config --openssldir=/packages/openssl1.0/
make
make install
rm -R /home/admin/temp_packages/openssl-1.0.2
