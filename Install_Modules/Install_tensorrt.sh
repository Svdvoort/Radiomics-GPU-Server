#!/bin/bash

tensorrt_version="4.0.1.6"
tensorrt_file="/home/svandervoort/Downloads/TensorRT-4.0.1.6.Ubuntu-16.04.4.x86_64-gnu.cuda-9.2.cudnn7.1.tar.gz"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ ! -f ${tensorrt_file} ]; then
  echo "Unfortunately tensorrt can not be downloaded automatically"
  echo "Please downlad the library manually and adjust the path in this script"
fi

tensorrt_file_name=(${tensorrt_file//\// })
tensorrt_file_name="${tensorrt_file_name[-1]}"


install_folder="/packages/tensorrt/${tensorrt_version}"
mkdir -p ${install_folder}

tar -xzf ${tensorrt_file} -C ${install_folder}

mkdir -p /etc/modulefiles/nvidia-tools/tensorrt
${DIR}/Module_files/create_tensorrt_module_file.sh "${tensorrt_version}" "/etc/modulefiles/nvidia-tools/tensorrt/${tensorrt_version}"
cp ${DIR}/Module_files/tensorrt_version /etc/modulefiles/nvidia-tools/tensorrt/.version
