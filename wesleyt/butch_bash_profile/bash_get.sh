#!/bin/bash
#This is a comment used to see if it worked.
ssh  wesleyt@nbcbanwfjobt <<EOF
bash_zip.sh 
EOF

scp wesleyt@nbcbanwfjobt:~/butch_bash_backup.zip ~/
cd ~/
unzip butch_bash_backup.zip
rm butch_bash_backup.zip
dot
