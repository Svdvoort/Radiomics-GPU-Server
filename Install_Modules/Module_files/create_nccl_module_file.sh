#!/bin/bash

nccl_version=$1
module_file=$2

echo "#%Module1.0" > $module_file
echo "" >> $module_file

echo "module-whatis \"Activate nccl ${nccl_version} for cuda 9.1, cudnn 7.1\"" >> $module_file

echo "" >> "$module_file"

# cuda
echo "set ncclroot /packages/nccl/${nccl_version}/nccl_2.2.13-1+cuda9.2_x86_64" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${ncclroot}/lib\"" >> $module_file

echo "" >> $module_file
echo "conflict nccl" >> $module_file
