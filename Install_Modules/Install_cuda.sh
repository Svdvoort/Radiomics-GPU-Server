#!/bin/bash

cuda_version=9.2.148

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

mkdir -p /home/admin/temp_packages/cuda
mkdir -p /packages/cuda/${cuda_version}
cd /home/admin/temp_packages/cuda

# Install cuda and add to Modules
if [ ${cuda_version} = "9.2.148" ]; then
cuda_file_url="https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux"
elif [ ${cuda_version} = "9.1.58" ]; then
cuda_file_url="https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run"
elif [ ${cuda_version} = "8.0.61" ]; then
cuda_file_url="https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb"
else
echo "Invalid cuda version given: ${cuda_version}"
exit 1
fi

cuda_package_file_name=(${cuda_file_url//\// })
run_file="${cuda_package_file_name[-1]}"
wget $cuda_file_url

# # According to installation instructions on nvidia website
chmod +x ${run_file}
./${run_file} --silent --driver --toolkit --toolkitpath="/packages/cuda/${cuda_version}" --verbose

# Now we have to add them to the modules environment
#mkdir -p /etc/modulefiles/cuda
#${DIR}/Module_files/create_cuda_module_file.sh "${cuda_version}" "/etc/modulefiles/nvidia-tools/cuda/${cuda_version}"
#cp ${DIR}/Module_files/cuda_version /etc/modulefiles/nvidia-tools/cuda/.version


# Cleanup
rm -R /home/admin/temp_packages/cuda
