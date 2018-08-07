#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

mkdir -p /home/admin/temp_packages/cuda
cd /home/admin/temp_packages/cuda

# Install cuda and add to Modules

for cuda_version in 9.2.148 9.1.58 8.0.61
do
  if [ ${cuda_version} = "9.2.148" ]; then
    cuda_file_url="https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda-repo-ubuntu1710-9-2-local_9.2.148-1_amd64"
  elif [ ${cuda_version} = "9.1.58" ]; then
    cuda_file_url="https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda-repo-ubuntu1704-9-1-local_9.1.85-1_amd64"
  elif [ ${cuda_version} = "8.0.61" ]; then
    cuda_file_url="https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb"
  fi

  cuda_package_file_name=(${cuda_file_url//\// })
  deb_file="${cuda_package_file_name[-1]}"
  wget $cuda_file_url

  # According to installation instructions on nvidia website
  dpkg -i --force-overwrite $deb_file
  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1710/x86_64/7fa2af80.pub
  apt-get update
  apt-get install -y -o Dpkg::Options::="--force-overwrite" --fix-broken cuda

  # Now we have to add them to the modules environment
  mkdir -p /etc/modulefiles/cuda
  ${DIR}/Module_files/create_cuda_module_file.sh "${cuda_version}" "/etc/modulefiles/cuda/${cuda_version}"
  cp ${DIR}/Module_files/cuda_version /etc/modulefiles/cuda/.version

  rm -R /home/admin/temp_packages/cuda
done
