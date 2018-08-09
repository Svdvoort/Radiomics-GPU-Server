#!/bin/bash

matlab_version=$1
matlab_version_elements=(${matlab_version//./ })
module_file=$2

echo "#%Module1.0" > $module_file
echo "##" >> $module_file
echo "## Matlab"  >> $module_file
echo "##" >> $module_file
echo "" >> $module_file

# Mianly copied from bigr-cluster settings
echo "proc ModulesHelp { } {"  >> $module_file
echo ""  >> $module_file
echo "        puts stderr \"\tSet up the Matlab on the path\""  >> $module_file
echo "        puts stderr \"\n\tVersion R2015b\n\""  >> $module_file
echo "}"  >> $module_file
echo "" >> $module_file

echo "module-whatis \"sets environment for Matlab ${matlab_version}\"" >> $module_file
echo "set              matlabroot              /packages/matlab/${matlab_version}" >> $module_file
echo "set hn [info hostname]"  >> $module_file
echo "" >> "$module_file"

# matlab
echo "prepend-path PATH \"\$matlabroot\bin\"" >> $module_file
echo "set-alias        matlab               \"\$matlabroot/bin/matlab\"" >> $module_file
echo "set-alias        mcc               \"\$matlabroot/bin/mcc -m -v -R -singleCompThread -R -nodesktop -R -nosplash\"" >> $module_file

echo "" >> $module_file
echo "conflict matlab" >> $module_file
