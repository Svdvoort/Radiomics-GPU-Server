#!/bin/bash

caffe_version=$1
module_file=$2

echo "#%Module1.0" > $module_file
echo "##" >> $module_file
echo "## Caffe ${caffe_version}"  >> $module_file
echo "##" >> $module_file
echo "" >> $module_file

echo "module-whatis \"Activate caffe ${caffe_version} (with GNU compilers and GPU-acceleration through cuDNN)\"" >> $module_file
echo "" >> "$module_file"

# caffe
echo "set             root                    /packages/caffe/${caffe_version}" >> $module_file
echo "prepend-path    LD_LIBRARY_PATH         \${root}/lib " >> $module_file
echo "prepend-path    PYTHONPATH              \${root}/python " >> $module_file
echo "prepend-path    PATH                    \${root}/bin " >> $module_file
echo "setenv          CAFFE_ROOT              \${root} " >> $module_file

echo "module load protobuf/v3.2.0 python/2.7.15 cuda/8.0.61 cudnn/8.0-v5.1 nccl/2.2.13 tools/matlab/R2015b " >> $module_file

echo "" >> $module_file
echo "conflict caffe" >> $module_file
