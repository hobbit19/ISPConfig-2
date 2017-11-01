#!/bin/bash
#
# ISPConfig 3 Install script.
#
# Script: install.sh
# Description: This Script ISPConfig Automation Installer for KSCloud

# Install Logging
exec > >(tee -i /usr/local/src/ispconfig_install.log)
exec 2>&1

# Global variables
WT_BACKTITLE="ISPConfig 3 Automation Installer for KSCloud"
red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color

# Current directory
PWD=$(pwd);

# Load Script
source $PWD/functions/presystemcheck.sh
source $PWD/functions/distros_check.sh
source $PWD/functions/askquestionsingleserver.s
source $PWD/functions/askquestionmultiserver.shh
source $PWD/functions/passwordgen.sh
source $PWD/ispconfig/singleserver.sh
source $PWD/ispconfig/multiserver.sh

# Check Linux distros
echo "Checking your system, please wait..."
LinuxDistros
PreSystemCheck

# Load Script
source $PWD/distros/$DISTRO/installer.sh

clear
echo "Welcome to ISPConfig Automation Install Script for KSCloud"
echo "This script developed by KSCloud(ysyuk910)"
echo
echo "========================================="
echo "ISPConfig 3 Automation installer"
echo "========================================="
echo
echo "This script will do a nearly unattended installation of"
echo "all software needed to run ISPConfig 3."
echo "When this script starts running, it'll keep going all the way"
echo "So before you continue, please make sure the following checklist is ok:"
echo
echo "- This is a clean standard clean installation for supported systems";
echo "- Internet connection is working properly";
echo
echo

echo "This Script ISPConfig Automation Installer for KSCloud"

echo -e "This Server detected Linux Distribution is :" $ID-$VERSION_ID

while [ "x$MULTISERVER" == "x" ]
    do
        MULTISERVER=$(whiptail --title "MULTISERVER SETUP" --backtitle "$WT_BACKTITLE" --nocancel --radiolist "Would you like to install ISPConfig in a MultiServer Setup?" 10 50 2 "no" "(default)" ON "yes" "" OFF 3>&1 1>&2 2>&3)
    done
if [ "$ID-$VERSION_ID" == "ubuntu-16.04" ]; then
    if [ "$MULTISERVER" == "yes" ]; then
        AskQuestionsMultiServer
        InstallUbuntuServer
        ISPConfigMultiServerInstall
    else
        AskQuestionsSingleServer
        InstallUbuntuServer
        ISPConfigSingleServerInstall
    fi
else
    if [ "$MULTISERVER" == "yes" ]; then
        AskQuestionsMultiServer
        InstallCentOSServer
        ISPConfigMultiServerInstall
    else
        AskQuestionsSingleServer
        InstallCentOSServer
        ISPConfigSingleServerInstall
    fi
fi


