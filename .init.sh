#!/bin/bash

default_name=myproject


echo -n "Name of the project without space)? "
read project

echo -n "Author's name (e.g. John Doe)? "
read author

echo -n "Author's email (e.g. john.doe@example.com)? "
read email

# hyphens are not allowed in Python modules, replace them with underscores
project=`echo $project | tr - _`

for input_file in setup.cfg Makefile pyproject.toml tests/tests.py
do
  sed -i '' "s/$default_name/$project/g
s/__author__/$author/g
s/__email__/$email/g" $input_file
done

mv -v $default_name $project
