#! /bin/bash

#ignore the tput error messages displayed when running this
#this is a bug that has to do with ssh when an interactive 
#terminal is not available as per this bug report
#https://bugzilla.redhat.com/show_bug.cgi?id=450424
local x
x=27
#===============================================================================
#Takes in a server name and ssh's into and calls passwd
#===============================================================================
function fill_servers(){
    echo "x = $x"
    x=2
    echo "x = $x"
    i=0
    read j
    while [ "$j" != "" ]; do
        if [ "${j:0:1}" != "#" ];then
	    servers[$i]=$j
	    echo "$i  ${servers[$i]}"
	    let "i += 1"
        fi
        read j
    done

    echo "---------- Finished $i----------"
}

#feed the server list to the change_password
#method

cat ./server_list.txt | fill_servers

echo "x = $x"
echo "Server 0 = ${servers[0]}"
#`ssh wesleyt@${servers[1]}`
#lastly, change the password on this sever
#passwd