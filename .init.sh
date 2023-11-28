#!/bin/bash

default_project=myproject
default_author="John Doe"
default_email="john.doe@example.com"

echo -n "Name of the project without space)? "
read project
project=${project:-$default_project}

echo -n "Author's name (e.g. $default_project)? "
read author
author=${author:-$default_author}

echo -n "Author's email (e.g. $default_email)? "
read email
email=${email:-$default_email}

# hyphens are not allowed in Python modules, replace them with underscores
project=`echo $project | tr - _`

for input_file in setup.cfg Makefile pyproject.toml tests/tests.py
do
  sed -i '' "s/$default_project/$project/g
             s/__author__/$author/g
             s/__email__/$email/g" $input_file
done

mv -v $default_project $project
