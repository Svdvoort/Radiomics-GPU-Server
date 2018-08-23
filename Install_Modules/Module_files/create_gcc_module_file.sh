#!/bin/bash

gcc_version=$1
gcc_version_elements=(${gcc_version//./ })
module_file=$2

echo "#%Module1.0" > $module_file
echo "##" >> $module_file
echo "## gcc"  >> $module_file
echo "##" >> $module_file
echo "" >> $module_file

echo "module-whatis \"sets application for gcc ${gcc_version}\"" >> $module_file
echo "set              gccroot              /packages/gcc/${gcc_version}" >> $module_file
echo "" >> "$module_file"

# gcc
echo "prepend-path PATH \"\$gccroot/bin\"" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\$gccroot/lib:\$gccroot/lib64\"" >> $module_file

echo "" >> $module_file
echo "conflict gcc" >> $module_file
