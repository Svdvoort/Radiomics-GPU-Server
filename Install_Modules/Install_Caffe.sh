#!/bin/bash

# NOTE: Does not work yet as administrator, as sudo account cannot load modules.

# There are several settings we need to adjust in the cmake configuration
# in order to install Caffe on the cluster
caffe_config="/home/mstarmans/Radiomics-GPU-Server/Install_Modules/Module_files/CaffeMakefile.config"
caffe_version="1.0"
python_version="2.7.15"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ ! -f ${caffe_config} ]; then
  echo "Please provide a caffe configuration file"
fi

if [ ! ${caffe_version} ]; then
  echo "Please provide a caffe version"
fi

if [ ! ${python_version} ]; then
  echo "Please provide a python version"
fi

# Protobuf libararies need to have been uninstalled before installing protobuf
# See also https://github.com/BVLC/caffe/issues/3046
sudo apt-get remove protobuf-dev libprotobuf-dev

# Also, make sure you use a gcc compiler version 5.X

# Load required modules
module purge
module load python/${python_version}
module load cuda/8.0.61
module load protobuf/v3.2.0
module load cudnn/8.0-v5.1
module load nccl/2.2.13
module load tools/matlab/R2015b

# Create a temporary directory to work in
install_folder="/packages/caffe/${caffe_version}"
mkdir -p ${install_folder}
cd ${install_folder}

# Need some libraries
apt-get install -y libopencv-dev libopenblas-dev python-opencv
apt-get install -y libatlas-base-dev libboost-all-dev python-dev
apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev
apt-get install -y libhdf5-serial-dev libhdf5-dev protobuf-compiler
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
