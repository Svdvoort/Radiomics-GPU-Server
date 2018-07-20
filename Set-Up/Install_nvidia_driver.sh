#!/bin/bash

driver_version=396.45
# Make sure we're root otherwise this script won't work
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

mkdir -p /home/admin/temp_packages/nvidia_driver
cd /home/admin/temp_packages/nvidia_driver

# First we install the latest drivers
#Before we do that we need to disable the default drivers, otherwise it won't install
if [ ! -f /etc/modprobe.d/blacklist-nouveau.conf ]; then
  echo "blacklist nouveau" >> /etc/modprobe.d/blacklist-nouveau.conf
  echo "options nouveau modeset=0" >> /etc/modprobe.d/blacklist-nouveau.conf
  update-initramfs -u
  echo "Did some necessary pre-configuration. The system will reboot in 15 seconds"
  echo "Please run this script again after reboot to finish installation"
  sleep 15
  reboot
fi

wget "http://us.download.nvidia.com/XFree86/Linux-x86_64/${driver_version}/NVIDIA-Linux-x86_64-${driver_version}.run"
chmod +x NVIDIA-Linux-x86_64-${driver_version}.run
./NVIDIA-Linux-x86_64-${driver_version}.run
