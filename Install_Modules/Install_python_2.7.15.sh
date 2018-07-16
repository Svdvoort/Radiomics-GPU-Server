#!/bin/bash

# Update python version to the required version. Rest of script should work
# Don't forget to make a module script and a version file if it doesn't exist yet!
python_version="2.7.15"

python -V
# Make folder to store temporary files and get source
sudo mkdir /home/admin/temp_packages/
sudo mkdir /home/admin/temp_packages/python_"$python_version"


cd /home/admin/temp_packages/python_"$python_version"
sudo wget https://www.python.org/ftp/python/"$python_version"/Python-"$python_version".tgz
sudo tar -xzf Python-"$python_version".tgz
cd Python-"$python_version"

# Configure with the Module folder as target folder
sudo mkdir /packages/python/"$python_version"
sudo ./configure --prefix=/packages/python/"$python_version" --enable-optimizations
sudo make -j4
sudo make install

# Copy modules files to correct directories
sudo mkdir /etc/modulefiles/python
sudo cp /home/admin/Radiomics-GPU-Server/Install_Modules/Module_files/Python_"$python_version" /etc/modulefiles/python/"$python_version"
sudo cp /home/admin/Radiomics-GPU-Server/Install_Modules/Module_files/python_version /etc/modulefiles/python/.version

# Clean-up
sudo rm -R /home/admin/temp_packages/python_"$python_version"

# Check if properly installed
# Need to resource modules because otherwise it doesn't load

echo "Blablablab"

source /etc/profile.d/modules.sh
# module list

#source /etc/profile.d/modules.sh
#module load python/"$python_version"
#python -V

# Check if everything actually worked and the correct version is loaded
#pyv="$(python -c 'import platform; print(platform.python_version())')"
#if [ "$pyv" == "$python_version" ]; then
#    exit(0)
#else
#    exit(1)
#fi
