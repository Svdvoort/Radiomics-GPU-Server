#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

gcc_version=7.3.0
python_version=3.7.4
# This fix is needed since some Python versions do not find the openssl
# library otherwise, and thus can't use pip
apt-get install -y curl libffi-dev libssl-dev zlib1g-dev graphviz graphviz-dev
apt-get install -y build-essential python-dev libssl-dev libncurses*-dev liblzma-dev libgdbm-dev libsqlite3-dev libbz2-dev tk-dev

source /etc/profile.d/modules.sh

module purge
module load gcc/${gcc_version}


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"


# Fix openssl for python:
#if pyton_version=="2.7.12"; then
#	export LD_LIBRARY_PATH=/usr/lib/ssl/:$LD_LIBRARY_PATH
#	export LDFLAGS="-L/packages/openssl/1.0.1u/lib/ -L/packages/openssl/1.0.1u/lib64/"
#	export LD_LIBRARY_PATH="/packages/openssl/1.0.1u/lib/:/packages/openssl/1.0.1u/lib64/"
#	export CPPFLAGS="-I/packages/openssl/1.0.1u/include -I/packages/openssl/1.0.1u/include/openssl"
#fi

# Make folder to store temporary files and get source
mkdir -p /home/admin/temp_packages/python_"${python_version}"


cd /home/admin/temp_packages/python_"${python_version}"
wget https://www.python.org/ftp/python/"${python_version}"/Python-"${python_version}".tgz
tar -xzf Python-"${python_version}".tgz
cd Python-"${python_version}"

# Configure with the Module folder as target folder
mkdir -p /packages/python/"${python_version}"
./configure --prefix=/packages/python/"${python_version}" --enable-optimizations
make -j8
make install

# Copy modules files to correct directories
mkdir -p /etc/modulefiles/compilers/python
${DIR}/Module_files/create_python_module_file.sh "${python_version}" "/etc/modulefiles/compilers/python/${python_version}"
cp ${DIR}/Module_files/python_version /etc/modulefiles/compilers/python/.version


#We're going to install a specific version of pip for this version of python
source /etc/profile.d/modules.sh
module load python/"${python_version}"

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

python_version_elements=(${python_version//./ })
short_python_version="${python_version_elements[0]}.${python_version_elements[1]}"

/packages/python/${python_version}/bin/python${short_python_version} get-pip.py

# Install virtualenv so users can install their own packages
/packages/python/${python_version}/bin/pip${short_python_version} install virtualenv

# Clean-up
rm -R /home/admin/temp_packages/python_"${python_version}"
