#!/bin/bash

# matlab can't actually be installed automatically, we need to download it manually.
# Therefore we define the path to the downloaded file here
# Make sure you download the library(.tgz), not the runtim library (.deb)!
matlab_file="/home/mstarmans/ModuleFiles/MATLAB_R2015B.tar.gz"
matlab_version="R2015b"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [ ! -f ${matlab_file} ]; then
  echo "Unfortunately matlab can not be downloaded automatically"
  echo "Please download the library manually and adjust the path in this script"
fi

# Make temporary installation folder
temp_folder="/packages/matlab/temporary"
install_folder="/packages/matlab/${matlab_version}"
mkdir -p ${temp_folder}
mkdir -p ${install_folder}

# Unzip the tar file
tar -xzf ${matlab_file} -C ${temp_folder}
mv ${temp_folder}"/MATLAB/"${matlab_version}"/"${matlab_version} ${install_folder}
rm -r ${temp_folder}

# Add the module
mkdir -p /etc/modulefiles/tools/matlab/
${DIR}/Module_files/create_matlab_module_file.sh "${matlab_version}" "/etc/modulefiles/tools/matlab/${matlab_version}"
cp ${DIR}/Module_files/matlab_version /etc/modulefiles/tools/matlab/.version
