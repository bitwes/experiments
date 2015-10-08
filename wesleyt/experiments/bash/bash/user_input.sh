#!/bin/bash

echo hello enter something
read something

echo $something

if [ "$something" == "" ]
then
  echo you entered nothing
fi