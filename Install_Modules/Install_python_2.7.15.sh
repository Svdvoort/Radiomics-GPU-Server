#!/bin/bash

python -V
# Make folder to store temporary files and get source
sudo mkdir /home/admin/temp_packages/
sudo mkdir /home/admin/temp_packages/python_2_7_15


cd /home/admin/temp_packages/python_2_7_15
sudo wget https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz
sudo tar -xzf Python-2.7.15.tgz
cd Python-2.7.15

# Configure with the Module folder as target folder
sudo mkdir /packages/python/2.7.15
sudo ./configure --prefix=/packages/python/2.7.15 --enable-optimizations
sudo make -j4
sudo make install

# Copy modules files to correct directories
sudo mkdir /etc/modulefiles/python
sudo cp /home/admin/Radiomics-GPU-Server/Install_Modules/Module_files/Python_2.7.15 /etc/modulefiles/python/2.7.15
sudo cp /home/admin/Radiomics-GPU-Server/Install_Modules/Module_files/python_version /etc/modulefiles/python/.version

# Clean-up
sudo rm -R /home/admin/temp_packages/python_2_7_15

# Check if properly installed
# Need to resource modules because otherwise it doesn't load
source /etc/profile.d/modules.sh
module load python/2.7.15
python -V

# Check if everything actually worked and the correct version is loaded
pyv="$(python -c 'import platform; print(platform.python_version())')"
if [ "$pyv" == "2.7.15" ]; then
    exit(0)
else
    exit(1)
fi
