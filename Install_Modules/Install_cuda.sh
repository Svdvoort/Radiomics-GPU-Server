#!/bin/bash

cuda_version=10.1.105

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Disable nouveau if required
if [ $(lsmod | grep nouveau | head -c1 | wc -c) = 0 ]; then
	echo "Nouveau not found, continue!"
else
	touch /etc/modprobe.d/blacklist-nouveau.conf
	echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
	echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
	update-initramfs -u
	echo "Please reboot your computer and rerun the installation script!"
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
elif [ ${cuda_version} = "10.0.130" ]; then
cuda_file_url="https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux"
elif [ ${cuda_version} = "10.1.105" ]; then
cuda_file_url="https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_418.39_linux.run"

else
echo "Invalid cuda version given: ${cuda_version}"
exit 1
fi

cuda_package_file_name=(${cuda_file_url//\// })
run_file="${cuda_package_file_name[-1]}"
wget $cuda_file_url

# # According to installation instructions on nvidia website
chmod +x ${run_file}
./${run_file} --silent --driver --toolkit --toolkitpath="/packages/cuda/${cuda_version}"

# Now we have to add them to the modules environment
mkdir -p /etc/modulefiles/nvidia-tools/cuda/
${DIR}/Module_files/create_cuda_module_file.sh "${cuda_version}" "/etc/modulefiles/nvidia-tools/cuda/${cuda_version}"
cp ${DIR}/Module_files/cuda_version /etc/modulefiles/nvidia-tools/cuda/.version


# Cleanup
rm -R /home/admin/temp_packages/cuda
