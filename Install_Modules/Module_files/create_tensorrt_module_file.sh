#!/bin/bash

cuda_version=$1
tensorrt_version=$2
module_file=$3

echo "#%Module1.0" > $module_file
echo "" >> $module_file

echo "module-whatis \"Activate tensorrt ${tensorrt_version} for cuda ${cuda_version}\"" >> $module_file

echo "" >> "$module_file"

# cuda
echo "set tensorrtroot /packages/tensorrt/Cuda-${cuda_version}/${tensorrt_version}" >> $module_file
echo "prepend-path PATH \"\${tensorrtroot}/bin\"" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${tensorrtroot}/lib\"" >> $module_file

echo "" >> $module_file
echo "conflict tensorrt" >> $module_file
