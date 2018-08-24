#!/bin/bash

python_version=$1
python_version_elements=(${python_version//./ })
short_python_version="${python_version_elements[0]}.${python_version_elements[1]}"
module_file=$2

echo "#%Module1.0" > $module_file
echo "" >> $module_file

echo "module-whatis \"Activate Python ${python_version}\"" >> $module_file

echo "" >> "$module_file"

# python
echo "setenv PYTHONVERSION $python_version" >> $module_file
echo "set pythonroot /packages/python/${python_version}" >> $module_file
echo "prepend-path PATH \"\${pythonroot}/bin\"" >> $module_file
echo "prepend-path LD_LIBRARY_PATH \"\${pythonroot}/lib:\${pythonroot}/lib/${short_python_version}\"" >> $module_file
echo "prepend-path PYTHONPATH \"\${pythonroot}\"" >> $module_file

echo "" >> $module_file
echo "conflict python" >> $module_file
