#!/bin/bash

# Text color variables
txtund=$(tput sgr 0 1)    # Underline
txtbld=$(tput bold)       # Bold
txtred=$(tput setaf 1)    # Red
txtgrn=$(tput setaf 2)    # Green
txtylw=$(tput setaf 3)    # Yellow
txtblu=$(tput setaf 4)    # Blue
txtpur=$(tput setaf 5)    # Purple
txtcyn=$(tput setaf 6)    # Cyan
txtwht=$(tput setaf 7)    # White
txtrst=$(tput sgr0)       # Text reset

echo "A great color is ${txtylw}yellow${txtrst}."

echo "${txtblu} -------------------------"
echo "-----------------afa-adsf${txtpur}-af--a-df-asd-afds"
echo "more more more more ${txtrst} reset now"