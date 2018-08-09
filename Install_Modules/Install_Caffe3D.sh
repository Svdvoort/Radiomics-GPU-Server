#!/bin/bash

# NOTE: Does not work yet as administrator, as sudo account cannot load modules. Additionally,
# there seem to be some errors in the making process.

# There are several settings we need to adjust in the cmake configuration
# in order to install Caffe on the cluster
caffe_config="/home/mstarmans/Radiomics-GPU-Server/Install_Modules/Module_files/Caffe3DMakefile.config"
caffe3D_version="3D-Caffe"
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

if [ ! ${caffe3D_version} ]; then
  echo "Please provide a caffe3D version"
fi

if [ ! ${caffe_version} ]; then
  echo "Please provide a caffe version"
fi

if [ ! ${python_version} ]; then
  echo "Please provide a python version"
fi

# Protobuf libararies need to have been uninstalled before installing protobuf
# See also https://github.com/BVLC/caffe/issues/5645
# sudo apt-get remove protobuf-dev libprotobuf-dev

# # Load required modules
# module load python/${python_version}
# module load cuda/8.0.61
# module load cudnn/8.0-v5.1
# module load protobuf/v3.2.0
# module load nccl/2.2.13
# module load tools/matlab/R2015b
# module load caffe/${caffe_version}

# Create a temporary directory to work in
install_folder="/packages/caffe3D/python_${python_version}"
rm -R ${install_folder}
mkdir -p ${install_folder}
cd ${install_folder}

# Beforehand, apply a fix as suggested by https://github.com/NVIDIA/DIGITS/issues/105
# cd /packages/caffe/1.0
# protoc /packages/caffe/1.0/src/caffe/proto/caffe.proto --cpp_out=.
# mkdir -p /packages/caffe/1.0/include/caffe/proto
# mv /packages/caffe/1.0/src/caffe/proto/caffe.pb.h /packages/caffe/1.0/include/caffe/proto
# cd ${install_folder}

# Clone Caffe repository
git clone https://github.com/yulequan/3D-Caffe ${caffe3D_version}
cd ${caffe3D_version}
git checkout 3D-Caffe

# Clone correct makefile into repository
cp ${caffe_config} Makefile.config
make -j4
# make pycaffe
# make matcaffe
#
# # Add package to python path: not sure if this is proper way
# # echo 'export PYTHONPATH=${install_folder}/python:$PYTHONPATH' >> ~/.bashrc
# mkdir -p /etc/modulefiles/caffe3D/
# ${DIR}/Module_files/create_caffe3D_module_file.sh "${caffe_version}" "${caffe3D_version}" "${python_version}" "/etc/modulefiles/caffe3D/python${python_version}-${caffe3D_version}"
# cp ${DIR}/Module_files/caffe3D_version /etc/modulefiles/caffe3D/.version
