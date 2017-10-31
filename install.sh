#!/usr/bin/env bash
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

# Check Linux distros
source $PWD/functions/distros_check.sh
echo "Checking your system, please wait..."
CheckLinux

# Load Script
source $PWD/functions/*.sh
source $PWD/distros/$DISTRO/*.sh

clear

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


