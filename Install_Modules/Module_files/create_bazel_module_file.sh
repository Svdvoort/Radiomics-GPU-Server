#!/bin/bash

bazel_version=$1
cuda_version_elements=(${cuda_version//./ })
short_cuda_version="${cuda_version_elements[0]}.${cuda_version_elements[1]}"
module_file=$2

echo "#%Module1.0" > $module_file
echo "" >> $module_file

echo "module-whatis \"Activate Bazel ${bazel_version}\"" >> $module_file

echo "" >> "$module_file"

# cuda
echo "set bazelroot /packages/bazel/${bazel_version}" >> $module_file
echo "prepend-path PATH \"\${bazelroot}\"" >> $module_file

echo "" >> $module_file
echo "conflict bazel" >> $module_file
