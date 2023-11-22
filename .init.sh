#!/bin/bash

default_name=myproject

echo -n "Name of the project without space)? "
read project

for input_file in setup.cfg Makefile pyproject.toml
do
  sed -i '' "s/$default_name/$project/g" $input_file
done

mv -v $default_name $project
