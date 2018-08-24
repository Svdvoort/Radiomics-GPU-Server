#!/bin/bash

tensorflow_version=$1
module_file=$2
cuda_version=$3
cuddn_version=$4
tensorrt_version=$5
nccl_version=$6

echo "#%Module1.0" > $module_file
echo "" >> $module_file

echo "module-whatis \"Loads the Tensorflow ${tensorflow_version} and the required libraries\"" >> $module_file
echo "set tensorflowroot /packages/tensorflow/${tensorflow_version}/Python-${PYTHONVERSION}" >> $module_file
echo "" >> "$module_file"

echo "module load cuda/${cuda_version}" >> $module_file
echo "module load cudnn/${cudnn_version}" >> $module_file
echo "module load tensorrt/${tensorrt_version}" >> $module_file
echo "module load nccl/${nccl_version}" >> $module_file

echo "prepend-path PYTHONPATH \"\${tensorflowroot}\"" >> $module_file

echo "" >> $module_file
echo "conflict tensorflow" >> $module_file
