#!/bin/bash

# There are several settings we need to adjust in the cmake configuration
# in order to install Caffe on the cluster
caffe_config="./Module_files/CaffeMakefile.config"
caffe_version="1.0"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ ! -f ${caffe_config} ]; then
  echo "Please provide a caffe configuration file"
fi

if [ ! -f ${caffe_version} ]; then
  echo "Please provide a caffe version"
fi

# Create a temporary directory to work in
install_folder="/packages/caffe/${caffe_version}"
mkdir -p ${install_folder}
cd ${install_folder}

# Need some libraries
apt-get install -y libopencv-dev libopenblas-dev python-opencv
apt-get install -y libatlas-base-dev libboost-all-dev python-dev
apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev
apt-get install -y libhdf5-serial-dev protobuf-compiler
apt-get install -y libgflags-dev libgoogle-glog-dev liblmdb-dev

# Clone Caffe repository
git clone https://github.com/BVLC/caffe v1.0
cd v1.0
git checkout tags/1.0

# Clone correct makefile into repository
cp ${caffe_config} Makefile.config
make -j4
make pycaffe
make matcaffe

# Add package to python path
mkdir -p /etc/modulefiles/caffe/
${DIR}/Module_files/create_caffe_module_file.sh "${caffe_version}" "/etc/modulefiles/caffe/${caffe_version}"
cp ${DIR}/Module_files/caffe_version /etc/modulefiles/caffe/.version
