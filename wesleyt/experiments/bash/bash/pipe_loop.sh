#!/bin/bash

#This was some practice sending a pipe to a method to do something
#per line.  in this case, it was doing an ls on a list of extensions
#function() {
    read j
    while [ "$j" != "" ]; do
	echo "${txtund}${txtcyn}$j${txtrst}" 
	echo "`ls *.$j -l`"
	echo
	read j
    done
#{


 