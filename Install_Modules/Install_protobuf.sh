#!/bin/bash

protobuf_version=v3.2.0
short_version=${protobuf_version:1:1}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Make installation and temporary folders
install_folder="/packages/protobuf/${protobuf_version}"
mkdir -p /home/admin/temp_packages/protobuf
rm -R ${install_folder}
mkdir -p ${install_folder}
cd /home/admin/temp_packages/protobuf

# Get the protobuf tar and install source, only for python support
wget https://github.com/google/protobuf/releases/download/${protobuf_version}/protobuf-python-${protobuf_version:1:10}.tar.gz
tar -xvf protobuf-python-${protobuf_version:1:10}.tar.gz
protobuf-${protobuf_version:1:10}/configure --prefix=${install_folder}
make -j4
make install

# Add to modules
mkdir -p /etc/modulefiles/protobuf
${DIR}/Module_files/create_protobuf_module_file.sh "${protobuf_version}" "/etc/modulefiles/protobuf/${protobuf_version}"
cp ${DIR}/Module_files/protobuf_version /etc/modulefiles/protobuf/.version

# Clean up
rm -R /home/admin/temp_packages/protobuf
