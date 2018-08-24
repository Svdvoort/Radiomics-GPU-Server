#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

https://github.com/bazelbuild/bazel/releases/download/0.16.1/bazel-0.16.1-dist.zip
https://github.com/bazelbuild/bazel/releases/download/0.16.0/bazel-0.16.0-dist.zip

# This fix is needed since some Python versions do not find the openssl
# library otherwise, and thus can't use pip
apt-get install -y build-essential openjdk-8-jdk python zip unzip

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Update python version to the required version. Rest of script should work
# Don't forget to make a module script and a version file if it doesn't exist yet!
bazel_version=$1

temp_dir=/home/admin/temp_packages/bazel_"${bazel_version}"
# Make folder to store temporary files and get source
mkdir -p ${temp_dir}


cd ${temp_dir}
wget https://github.com/bazelbuild/bazel/releases/download/${bazel_version}/bazel-${bazel_version}-dist.zip
unzip bazel-${bazel_version}-dist.zip
./compile.sh

package_dir=/packages/bazel/"${bazel_version}"
mkdir -p ${package_dir}
cp ./output/bazel ${package_dir}/bazel

# Copy modules files to correct directories
mkdir -p /etc/modulefiles/compilers/bazel/
${DIR}/Module_files/create_bazel_module_file.sh "${bazel_version}" "/etc/modulefiles/compilers/bazel/${bazel_version}"
cp ${DIR}/Module_files/bazel_version /etc/modulefiles/compilers/bazel/.version

# Clean-up
rm -R $temp_dir
