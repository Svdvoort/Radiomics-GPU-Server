#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Update python version to the required version. Rest of script should work
# Don't forget to make a module script and a version file if it doesn't exist yet!
python_version=$1

# Need some packages for ssl support
apt-get install libffi-dev libssl-dev zlib1g-dev

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
mkdir -p /etc/modulefiles/python
${DIR}/Module_files/create_python_module_file.sh "${python_version}" "/etc/modulefiles/python/${python_version}"
cp ${DIR}/Module_files/python_version /etc/modulefiles/python/.version


#We're going to install a specific version of pip for this version of python
source /etc/profile.d/modules.sh
module load python/"${python_version}"

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

python_version_elements=(${python_version//./ })
short_python_version="${python_version_elements[0]}.${python_version_elements[1]}"

/packages/python/${python_version}/bin/${short_python_version} get-pip.py

# Clean-up
rm -R /home/admin/temp_packages/python_"${python_version}"
