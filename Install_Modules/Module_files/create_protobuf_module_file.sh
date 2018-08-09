#!/bin/bash

protobuf_version=$1
protobuf_version_elements=(${protobuf_version//./ })
module_file=$2

echo "#%Module1.0" > $module_file
echo "##" >> $module_file
echo "## Protobuf ${protobuf_version}"  >> $module_file
echo "##" >> $module_file
echo "" >> $module_file

echo "module-whatis \"Activate protobuf  ${protobuf_version}\"" >> $module_file
echo "set             root                   /packages/protobuf/${protobuf_version}" >> $module_file
echo "prepend-path	PATH			\${root}/bin/" >> $module_file
echo "prepend-path	PATH			\${root}/bin" >> $module_file
echo "prepend-path    LD_LIBRARY_PATH         \${root}/lib" >> $module_file
echo "setenv		PROTOBUF_LIBRARY	\${root}/lib" >> $module_file
echo "setenv		PROTOBUF_INCLUDE_DIR	\${root}/include" >> $module_file
echo "setenv		PROTOBUF_ROOT_DIR	\${root}" >> $module_file
echo "set-alias		protoc	\${root}/bin//protoc" >> $module_file

echo "" >> $module_file
echo "conflict protobuf" >> $module_file
