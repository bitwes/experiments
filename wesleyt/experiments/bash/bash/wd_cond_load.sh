#!/bin/bash

path=`pwd`
to_match='/home/wesleyt/development/'

echo $path
echo "looking for $to_match"

if [[ $path =~ "^$to_match" ]]; then
  echo "found match"
else
  echo "missed it"
fi