#!/bin/bash

cuda_version=$1
cuda_version_elements=(${cuda_version//./ })
short_cuda_version="${cuda_version_elements[0]}.${cuda_version_elements[1]}"
module_file=$2

echo "#%Module1.0" > $module_file
echo "" >> $module_file

echo "module-whatis \"Activate cuda ${cuda_version}\"" >> $module_file

echo "" >> "$module_file"

# cuda
echo "set cudaroot /usr/local/cuda-${short_cuda_version}" >> $module_file
echo "prepend-path PATH \"\${cudaroot}/bin\"" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${cudaroot}/lib64\"" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${cudaroot}/lib\"" >> $module_file

echo "" >> $module_file
echo "conflict cuda" >> $module_file
