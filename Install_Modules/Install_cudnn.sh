#!/bin/bash

# cudnn can't actually be installed automatically, we need to download it manually.
# Obtainable from the nvidia website after registration: https://developer.nvidia.com/cudnn
# Therefore we define the path to the downloaded file here
cudnn_file="/home/svdvoort/TEMP/cudnn-10.1-linux-x64-v7.6.4.38.tgz"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ ! -f ${cudnn_file} ]; then
  echo "Unfortunately cudnn can not be downloaded automatically"
  echo "Please downlad the library manually and adjust the path in this script"
fi

file_name=(${cudnn_file//\// })
file_name="${file_name[-1]}"
split_file_name=(${file_name//-/ })

cuda_version="${split_file_name[1]}"
cudnn_version="${split_file_name[4]}"
# Need to remove the ".tgz" for the cudnn version
cudnn_version="${cudnn_version::-4}"

install_folder="/packages/cudnn/Cuda-${cuda_version}/${cudnn_version}"
mkdir -p ${install_folder}

tar -xzf ${cudnn_file} -C ${install_folder}

mkdir -p /etc/modulefiles/nvidia-tools/cudnn/
${DIR}/Module_files/create_cudnn_module_file.sh "${cuda_version}" "${cudnn_version}" "/etc/modulefiles/nvidia-tools/cudnn/${cuda_version}-${cudnn_version}"
cp ${DIR}/Module_files/cudnn_version /etc/modulefiles/nvidia-tools/cudnn/.version
