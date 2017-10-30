#!/usr/bin/env bash
#
# ISPConfig 3 Install script for KSCloud
#
# Script: install.sh
# Description: This Script ISPConfig Automation Install for KSCloud

# Install Logging
exec > >(tee -i /usr/local/src/ispconfig_install.log)
exec 2>&1

# Global variables
CFG_HOSTNAME_FQDN=`hostname -f`;
WT_BACKTITLE="ISPConfig 3 Automation Install for KSCloud"

# Bash Colour
red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color

# Current directory
PWD=$(pwd);

# Check Linux distros
source $PWD/functions/distros_check.sh
echo "Checking your system, please wait..."
CheckLinux

# Load install Script

source $PWD/distros/$DISTRO/preinstallcheck.sh
source $PWD/distros/$DISTRO/questions.sh

source $PWD/distros/$DISTRO/install_basics.sh
source $PWD/distros/$DISTRO/install_postfix.sh
source $PWD/distros/$DISTRO/install_mysql.sh
source $PWD/distros/$DISTRO/install_mta.sh
source $PWD/distros/$DISTRO/install_antivirus.sh
source $PWD/distros/$DISTRO/install_webserver.sh
source $PWD/distros/$DISTRO/install_hhvm.sh
source $PWD/distros/$DISTRO/install_ftp.sh
source $PWD/distros/$DISTRO/install_quota.sh
source $PWD/distros/$DISTRO/install_bind.sh
source $PWD/distros/$DISTRO/install_webstats.sh
source $PWD/distros/$DISTRO/install_jailkit.sh
source $PWD/distros/$DISTRO/install_fail2ban.sh
source $PWD/distros/$DISTRO/install_webmail.sh
source $PWD/distros/$DISTRO/install_metronom.sh
source $PWD/distros/$DISTRO/install_ispconfig.sh
source $PWD/distros/$DISTRO/install_fix.sh