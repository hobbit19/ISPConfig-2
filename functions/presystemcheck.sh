# Presystem check

PreSystemCheck() {
# Check if user is root
    if [ $(id -u) != "0" ]; then
        echo -n "Error: You must be root to run this script, please use the root user to install the software."
        exit 1
    fi
  
# Check connectivity
    echo -e "Checking internet connection..."
    ping -q -c 3 www.ispconfig.org > /dev/null 2>&1

    if [ ! "$?" -eq 0 ]; then
        echo -e "${red}ERROR: Couldn't reach www.ispconfig.org, please check your internet connection${NC}"
        exit 1;
    fi
  
# Check for already installed ispconfig version
    if [ -f /usr/local/ispconfig/interface/lib/config.inc.php ]; then
        echo "ISPConfig is already installed. Uninstall to ISPConfig installer folder "php -q uninstall.php""
	    exit 1
    fi
  
    echo -e "${green}OK${NC}\n"
}