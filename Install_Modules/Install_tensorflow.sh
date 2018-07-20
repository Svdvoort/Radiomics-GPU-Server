#!/bin/bash

tensorflow_version="1.9.0"
python_version="3.7.0"

python_tensorflow_directory="/packages/tensorflow/python_${python_version}/${tensorflow_version}"

# Load the modules for which we want to install this tensorflow
# Start with purge to make sure we have everything we actually want
source /etc/profile.d/modules.sh

module purge all
module load python/${python_version}
module load cuda/9.2.148
module load cudnn/9.2-v7.1
module load tensorrt/4.0.1.6


# We will install Tensorflow from source to inlude all optimizations

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

temp_dir=/home/admin/temp_packages/tensorflow
mkdir -p ${temp_dir}
cd ${temp_dir}

# Need curl
apt-get -y install curl

# Start by installing bazel
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get -y install oracle-java8-installer

echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
apt-get update
apt-get -y install bazel

# Get python dependencies for tensorflow
python_version_elements=(${python_version//./ })
python_main_version="${python_version_elements[0]}"
if [ python_main_version = "2" ]; then
  # Python 2
  apt-get install -y python-dev python-pip python-wheel
  /packages/python/${python_version}/bin/pip install numpy
  /packages/python/${python_version}/bin/pip install enum34
  /packages/python/${python_version}/bin/pip install mock
elif [ python_main_version = "3" ]; then
  # Python 3
  apt-get install -y python3-dev python3-pip python3-wheel
  /packages/python/${python_version}/bin/pip3 install install numpy
  /packages/python/${python_version}/bin/pip3 install install enum34
  /packages/python/${python_version}/bin/pip3 install install mock

# # Get tensorflow
# git clone https://github.com/tensorflow/tensorflow
cd tensorflow
# git checkout v${tensorflow_version}
echo "Now going to configure tensorflow"
echo "Accept all defaults untill it asks for CUDA installation, here selection yes"
echo "Then input the following:"
echo "Cuda version: 9.2"
echo "Cuda path: /usr/local/cuda-9.2/"
echo "cuDNN version: 7.1"
echo "cuDNN path: /packages/cudnn/Cuda-9.2/v7.1/cuda/"
echo "Accept TensorRT support"
echo "TensorRT path: /packages/tensorrt/4.0.1.6/TensorRT-4.0.1.6/"
echo "Apart from this accept all default values again"
#./configure

# There is an error in Ubuntu 18.04 which will make bazel not get the correct packages
# This has to be fixed manually:
# Download jre from here: http://www.oracle.com/technetwork/java/javase/downloads/jre10-downloads-4417026.html
# Extract jre-10.0.2/lib/security/cacerts to ~/cacerts
# sudo cp -i ~/cacerts /etc/ssl/certs/java

echo "If bazel gives an error: Encountered error while reading extension file 'closure/defs.bzl'"
echo "and: All mirrors are down: [java.lang.RuntimeException: Unexpected error: java.security.InvalidAlgorithmParameterException: the trustAnchors parameter must be non-empty]"
echo "Check out the comments in source for a fix"

bazel build --config=opt --verbose_failures //tensorflow/tools/pip_package:build_pip_package

bazel-bin/tensorflow/tools/pip_package/build_pip_package ${python_tensorflow_directory}
/packages/python/${python_version}/bin/pip install ${python_tensorflow_directory}/*.whl
