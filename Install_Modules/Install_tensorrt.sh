#!/bin/bash

tensorrt_file="/home/svandervoort/TEMP/TensorRT-6.0.1.5.Ubuntu-18.04.x86_64-gnu.cuda-10.1.cudnn7.6.tar.gz"

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



split_file_name=(${tensorrt_file_name//-/ })
tensorrt_version_split=(${split_file_name[1]//.Ubuntu/ })

cuda_split=(${split_file_name[4]//.cudnn/ })

#cuda_split=(${cuda_split//.cudnn/ })

cuda_version="${cuda_split[0]}"
tensorrt_version="${tensorrt_version_split[0]}"
echo ${tensorrt_version}


install_folder="/packages/tensorrt/Cuda-${cuda_version}/${tensorrt_version}"
mkdir -p ${install_folder}

tar -xzf ${tensorrt_file} --strip-components=1 -C ${install_folder}

mkdir -p /etc/modulefiles/nvidia-tools/tensorrt
${DIR}/Module_files/create_tensorrt_module_file.sh "${cuda_version}" "${tensorrt_version}" "/etc/modulefiles/nvidia-tools/tensorrt/${cuda_version}-${tensorrt_version}"
cp ${DIR}/Module_files/tensorrt_version /etc/modulefiles/nvidia-tools/tensorrt/.version
