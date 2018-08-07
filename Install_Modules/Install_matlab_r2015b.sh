#!/bin/bash

# matlab can't actually be installed automatically, we need to download it manually.
# Therefore we define the path to the downloaded file here
# Make sure you download the library(.tgz), not the runtim library (.deb)!
matlab_file="/home/mstarmans/ModuleFiles/MATLAB_R2015B.tar.gz"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ ! -f ${matlab_file} ]; then
  echo "Unfortunately matlab can not be downloaded automatically"
  echo "Please download the library manually and adjust the path in this script"
fi

file_name=(${matlab_file//\// })
file_name="${file_name[-1]}"
split_file_name=(${file_name//-/ })

matlab_version="${split_file_name[4]}"
# Need to remove the ".tar.tgz" for the matlab version
matlab_version="${matlab_version::-7}"

install_folder="/packages/matlab/${matlab_version}"
mkdir -p ${install_folder}

tar -xzf ${matlab_file} -C ${install_folder}

mkdir -p /etc/modulefiles/matlab/
${DIR}/Module_files/create_matlab_module_file.sh "${matlab_version}" "/etc/modulefiles/matlab/${matlab_version}"
cp ${DIR}/Module_files/matlab_version /etc/modulefiles/matlab/.version
