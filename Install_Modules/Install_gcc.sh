#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

gcc_version=$1

# Install prerequisites
#apt-get install -y libgmp3-dev libmpfr-dev libmpfr-doc libmpfr4 libmpfr4-dbg
apt-get install -y gcc-multilib g++-multilib libc6:i386 libstdc++6:i386 libc6-dev:i386

# Install GCC version
# Create an installation directorie
install_dir=/packages/gcc/${gcc_version}
temp_dir=/home/admin/temp_packages/gcc-${gcc_version}
mkdir -p ${install_dir}
mkdir -p ${temp_dir}
cd ${temp_dir}

# Download source binaries
source_url="ftp://ftp.nluug.nl/mirror/languages/gcc/releases/gcc-${gcc_version}/gcc-${gcc_version}.tar.gz"
wget ${source_url}

# Unpack the binaries
mkdir -p ${temp_dir}/src
tar -xzf "gcc-${gcc_version}.tar.gz" -C src
cd src/gcc-${gcc_version}
./contrib/download_prerequisites

# Install according to official instructions:https://gcc.gnu.org/install/
cd ../..
src/gcc-${gcc_version}/configure --prefix=${install_dir} --disable-multilib
make #-j 4
make install

# Add modulefile to modulefiles folder
mkdir -p /etc/modulefiles/compilers/gcc
${DIR}/Module_files/create_gcc_module_file.sh "${gcc_version}" "/etc/modulefiles/compilers/gcc/${gcc_version}"
cp ${DIR}/Module_files/gcc_version /etc/modulefiles/compilers/gcc/.version

# Cleanup
rm -R ${temp_dir}
