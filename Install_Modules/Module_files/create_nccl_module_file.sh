#!/bin/bash

cuda_version=$1
nccl_version=$2
module_file=$3

echo "#%Module1.0" > $module_file
echo "" >> $module_file

echo "module-whatis \"Activate nccl ${nccl_version} for cuda ${cuda_version}\"" >> $module_file

echo "" >> "$module_file"

# cuda
echo "set ncclroot /packages/nccl/Cuda-${cuda_version}/${nccl_version}" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${ncclroot}/lib\"" >> $module_file

echo "" >> $module_file
echo "conflict nccl" >> $module_file
