#!/bin/bash
## SETTINGS
tensorflow_version=1.10.1
python_version=3.6.6

cuda_version=9.2.148
cudnn_version=9.2-v7.3.1.20
tensorrt_version=4.0.1.6
nccl_version=2.3.5
bazel_version=0.18.1
gcc_version=7.3.0

## PROGRAM, do not edit below this line
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Load the modules for which we want to install this tensorflow
# Start with purge to make sure we have everything we actually want
source /etc/profile.d/modules.sh

module purge
module load python/${python_version}
module load cuda/${cuda_version}
module load cudnn/${cudnn_version}
module load tensorrt/${tensorrt_version}
module load nccl/${nccl_version}
module load bazel/${bazel_version}
module load gcc/${gcc_version}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# We will install Tensorflow from source to inlude all optimizations
python_tensorflow_directory="/packages/tensorflow/wheels/python_${python_version}/${tensorflow_version}"



/packages/python/${python_version}/bin/pip${short_python_version} install --upgrade pip
/packages/python/${python_version}/bin/pip${short_python_version} install setuptools==39.1.0

temp_dir=/home/admin/temp_packages/tensorflow
mkdir -p ${temp_dir}
cd ${temp_dir}

# Need curl
apt-get -y install curl

# Get python dependencies for tensorflow
# NOTE: change this so that all the packages have a specified version
python_version_elements=(${python_version//./ })
python_main_version="${python_version_elements[0]}"
if [ $python_main_version = "2" ]; then
  # Python 2
  apt-get install -y python-dev python-pip python-wheel
  /packages/python/${python_version}/bin/pip install numpy
  /packages/python/${python_version}/bin/pip install enum34
  /packages/python/${python_version}/bin/pip install mock
  /packages/python/${python_version}/bin/pip install keras_applications --no-deps
  /packages/python/${python_version}/bin/pip install keras_preprocessing --no-deps
elif [ $python_main_version = "3" ]; then
  # Python 3
  apt-get install -y python3-dev python3-pip python3-wheel
  /packages/python/${python_version}/bin/pip3 install numpy
  /packages/python/${python_version}/bin/pip3 install enum34
  /packages/python/${python_version}/bin/pip3 install mock
  /packages/python/${python_version}/bin/pip3 install keras_applications --no-deps
  /packages/python/${python_version}/bin/pip3 install keras_preprocessing --no-deps
fi
#
# # Get tensorflow
git clone https://github.com/tensorflow/tensorflow
cd tensorflow
git checkout v${tensorflow_version}

cuda_version_elements=(${cuda_version//./ })
short_cuda_version="${cuda_version_elements[0]}.${cuda_version_elements[1]}"

splitted_cudnn_version=(${cudnn_version//v/ })
pure_cudnn_version="${splitted_cudnn_version[1]}"
cudnn_version_elements=(${pure_cudnn_version//./ })
short_cudnn_version="${cudnn_version_elements[0]}.${cudnn_version_elements[1]}"

nccl_version_elements=(${nccl_version//./ })
short_nccl_version="${nccl_version_elements[0]}.${nccl_version_elements[1]}"


echo "Now going to configure tensorflow"
if [ $python_main_version = "2" ]; then
    echo "Input this for Python version: /packages/python/${python_version}/bin/python"
elif [ $python_main_version = "3" ]; then
    echo "Input this for Python version: /packages/python/${python_version}/bin/python3"
fi
echo "Accept all defaults untill it asks for CUDA installation, here selection yes"
echo "Then input the following:"
echo "Cuda version: ${short_cuda_version}"
echo "Cuda path: /packages/cuda/${cuda_version}/"
echo "cuDNN version: ${short_cudnn_version}"
echo "cuDNN path: /packages/cudnn/Cuda-${short_cuda_version}/v${pure_cudnn_version}/cuda/"
echo "Accept TensorRT support"
echo "TensorRT path: /packages/tensorrt/${tensorrt_version}/TensorRT-${tensorrt_version}/"
echo "nccl version: ${short_nccl_version}"
echo "nccl path: /packages/nccl/${nccl_version}/nccl_${nccl_version}+cuda${short_cuda_version}_x86_64/"
echo "Apart from this accept all default values again"

./configure

# There is an error in Ubuntu 18.04 which will make bazel not get the correct packages
# This has to be fixed manually:
# Download jre from here: http://www.oracle.com/technetwork/java/javase/downloads/jre10-downloads-4417026.html
# Extract jre-10.0.2/lib/security/cacerts to ~/cacerts
# sudo cp -i ~/cacerts /etc/ssl/certs/java
# Then reboot the computer

echo "If bazel gives an error: Encountered error while reading extension file 'closure/defs.bzl'"
echo "and: All mirrors are down: [java.lang.RuntimeException: Unexpected error: java.security.InvalidAlgorithmParameterException: the trustAnchors parameter must be non-empty]"
echo "Check out the comments in source for a fix"

bazel build --config=opt --config=cuda --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --verbose_failures //tensorflow/tools/pip_package:build_pip_package

bazel-bin/tensorflow/tools/pip_package/build_pip_package ${python_tensorflow_directory}
/packages/python/${python_version}/bin/pip${short_python_version} install --target=/packages/tensorflow/${tensorflow_version}/Python-${python_version}/ --ignore-installed --upgrade ${python_tensorflow_directory}/*.whl

# Create a modules file
mkdir -p /etc/modulefiles/deeplearning/tensorflow
${DIR}/Module_files/create_tensorflow_module_file.sh "${tensorflow_version}" "/etc/modulefiles/deeplearning/tensorflow/${tensorflow_version}" "${cuda_version}" "${cudnn_version}" "${tensorrt_version}" "${nccl_version}"
cp ${DIR}/Module_files/tensorflow_version /etc/modulefiles/deeplearning/tensorflow/.version
cd $DIR
rm -R ${temp_dir}
