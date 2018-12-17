#!/bin/bash

nccl_version="2.2.13"
nccl_file="/home/svandervoort/Downloads/nccl_2.2.13-1+cuda9.2_x86_64.txz"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ ! -f ${nccl_file} ]; then
  echo "Unfortunately nccl can not be downloaded automatically"
  echo "Please downlad the library manually and adjust the path in this script"
fi

nccl_file_name=(${nccl_file//\// })
nccl_file_name="${nccl_file_name[-1]}"
nccl_name="${nccl_file_name%.*}"


install_folder="/packages/nccl/${nccl_version}"
mkdir -p ${install_folder}

tar -Jxf ${nccl_file} -C ${install_folder}

mkdir -p /etc/modulefiles/nvidia-tools/nccl/
${DIR}/Module_files/create_nccl_module_file.sh "${nccl_version}" "/etc/modulefiles/nvidia-tools/nccl/${nccl_version}" "${nccl_name}"
cp ${DIR}/Module_files/nccl_version /etc/modulefiles/nccl/.version
