#!/bin/bash

cuda_version=$1
cudnn_version=$2
module_file=$3

echo "#%Module1.0" > $module_file
echo "" >> $module_file

echo "module-whatis \"Activate cudnn ${cudnn_version} for cuda ${cuda_version}\"" >> $module_file

echo "" >> "$module_file"

# cuda
echo "set cudnnroot /packages/cudnn/Cuda-${cuda_version}/${cudnn_version}/cuda" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${cudnnroot}/lib64\"" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${cudnnroot}/include\"" >> $module_file
echo "setenv          CUDNN_ROOT              ${root}" >> $module_file

echo "" >> $module_file
echo "conflict cudnn" >> $module_file
