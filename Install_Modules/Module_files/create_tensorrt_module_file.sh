#!/bin/bash

tensorrt_version=$1
module_file=$2

echo "#%Module1.0" > $module_file
echo "" >> $module_file

echo "module-whatis \"Activate tensorrt ${tensorrt_version} for cuda 9.1, cudnn 7.1\"" >> $module_file

echo "" >> "$module_file"

# cuda
echo "set tensorrtroot /packages/tensorrt/${tensorrt_version}/TensorRT-${tensorrt_version}" >> $module_file
echo "prepend-path PATH \"\${tensorrtroot}/bin\"" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${tensorrtroot}/lib\"" >> $module_file

echo "" >> $module_file
echo "conflict tensorrt" >> $module_file
