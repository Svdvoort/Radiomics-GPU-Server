#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

ssl_version="1.0.1u"

openssl_URL="https://www.openssl.org/source/old"
main_version=${ssl_version:0:5}
full_url="${openssl_URL}/${main_version}/openssl-${ssl_version}.tar.gz"
mkdir -p /home/admin/temp_packages/openssl/${ssl_version}
mkdir -p /packages/openssl/${ssl_version}
cd /home/admin/temp_packages/openssl/${ssl_version}
wget ${full_url}
tar -xzf "openssl-${ssl_version}.tar.gz"

cd openssl-${ssl_version}
./config shared --prefix=/packages/openssl/${ssl_version} --openssldir=/packages/openssl/${ssl_version}
make
make install
rm -R /home/admin/temp_packages/openssl/${ssl_version}
