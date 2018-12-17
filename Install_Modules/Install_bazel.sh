#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

bazel_version=0.20.0

# This fix is needed since some Python versions do not find the openssl
# library otherwise, and thus can't use pip
apt-get install -y build-essential openjdk-8-jdk python zip unzip

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

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
