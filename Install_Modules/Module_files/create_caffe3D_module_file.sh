#!/bin/bash

caffe_version=$1
caffe3D_version=$2
python_version=$3
module_file=$4

echo "#%Module1.0" > $module_file
echo "##" >> $module_file
echo "## Caffe3D ${caffe3D_version}"  >> $module_file
echo "##" >> $module_file
echo "" >> $module_file

echo "module-whatis \"Activate caffe3D ${caffe3D_version} for caffe ${caffe_version} and python ${python_version}\"" >> $module_file
echo "" >> "$module_file"

# caffe
echo "set             root                    /packages/caffe3D/python_${python_version}/${caffe3D_version}" >> $module_file
echo "prepend-path    PYTHONPATH              \${root}/python " >> $module_file

echo "module load protobuf/v3.2.0 python/2.7.15 cuda/8.0.61 cudnn/8.0-v5.1 nccl/2.2.13 tools/matlab/R2015b caffe/1.0 " >> $module_file

echo "" >> $module_file
echo "conflict caffe" >> $module_file
