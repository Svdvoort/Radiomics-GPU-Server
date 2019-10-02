#!/bin/bash

#nccl_version="2.3.5"
nccl_file="/home/svandervoort/TEMP/nccl_2.4.8-1+cuda10.1_x86_64.txz"

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

split_file_name=(${nccl_file_name//_/ })
split_file_name=(${split_file_name[1]//-/ })

nccl_version="${split_file_name[0]}"
cuda_split_file_name=(${split_file_name[1]//cuda/ })
cuda_version="${cuda_split_file_name[1]}"

install_folder="/packages/nccl/Cuda-${cuda_version}/${nccl_version}"
mkdir -p ${install_folder}

tar -Jxf ${nccl_file} --strip-components=1 -C ${install_folder}

mkdir -p /etc/modulefiles/nvidia-tools/nccl/
${DIR}/Module_files/create_nccl_module_file.sh "${cuda_version}" "${nccl_version}" "/etc/modulefiles/nvidia-tools/nccl/${cuda_version}-${nccl_version}"
cp ${DIR}/Module_files/nccl_version /etc/modulefiles/nvidia-tools/nccl/.version
