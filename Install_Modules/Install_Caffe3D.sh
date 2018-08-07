#!/bin/bash

# There are several settings we need to adjust in the cmake configuration
# in order to install Caffe on the cluster
caffe_config="./Module_files/Caffe3DMakefile.config"
caffe3D_version="3D-Caffe"
caffe_version="1.0"
python_version="2.7.12"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ ! -f ${caffe_config} ]; then
  echo "Please provide a caffe configuration file"
fi

if [ ! -f ${caffe3D_version} ]; then
  echo "Please provide a caffe3D version"
fi

if [ ! -f ${caffe_version} ]; then
  echo "Please provide a caffe version"
fi

if [ ! -f ${python_version} ]; then
  echo "Please provide a python version"
fi

# Load required modules
module purge
module load python/${python_version}
module load cuda/8.0.61
module load cudnn/5.1
module load nccl/2.2.13
module load matlab/R2015B             # any matlab version
module load caffe/${caffe_version}

# Create a temporary directory to work in
install_folder="/packages/caffe3D/python_${python_version}/${caffe3D_version}"
mkdir -p ${install_folder}
cd ${install_folder}

# Clone Caffe repository
https://github.com/yulequan/3D-Caffe Caffe3D
cd Caffe3D
git checkout 3D-Caffe

# Clone correct makefile into repository
cp ${caffe_config} Makefile.config
make -j4
make pycaffe
make matcaffe

# Add package to python path: not sure if this is proper way
# echo 'export PYTHONPATH=${install_folder}/python:$PYTHONPATH' >> ~/.bashrc
