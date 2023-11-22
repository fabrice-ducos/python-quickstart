#!/bin/bash

default_name=myproject


echo -n "Name of the project without space)? "
read project

# hyphens are not allowed in Python modules, replace them with underscores
project=`echo $project | tr - _`

for input_file in setup.cfg Makefile pyproject.toml
do
  sed -i '' "s/$default_name/$project/g" $input_file
done

mv -v $default_name $project
