#!/bin/bash

cuda_version=$1
module_file=$2

echo "#%Module1.0" > $module_file
echo "" >> $module_file

echo "module-whatis \"Activate cuda ${cuda_version}\"" >> $module_file

echo "" >> "$module_file"

# cuda
echo "set cudaroot /packages/cuda/${cuda_version}" >> $module_file
echo "prepend-path PATH \"\${cudaroot}/bin\"" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${cudaroot}/lib64\"" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${cudaroot}/lib\"" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${cudaroot}/extras/CUPTI/lib64\"" >> $module_file

echo "" >> $module_file
echo "conflict cuda" >> $module_file
