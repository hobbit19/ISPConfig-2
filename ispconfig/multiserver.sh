# ISPConfig Single Server Install

ISPConfigMultiServerInstall(){
    
    echo -n "Installing ISPConfig... "
    cd /usr/local/src
    wget https://www.ispconfig.org/downloads/ISPConfig-3-stable.tar.gz
    tar xfz ISPConfig-3-stable.tar.gz
    cd ispconfig3_install/install/
    echo "Create INI file"
    touch autoinstall.ini
	echo "[install]" > autoinstall.ini
	echo "language=en" >> autoinstall.ini
	echo "install_mode=expert" >> autoinstall.ini
	echo "hostname=$CFG_HOSTNAME_FQDN" >> autoinstall.ini
	echo "mysql_hostname=localhost" >> autoinstall.ini
	echo "mysql_root_user=root" >> autoinstall.ini
	echo "mysql_root_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
	echo "mysql_database=dbispconfig" >> autoinstall.ini
	echo "mysql_port=3306" >> autoinstall.ini
	echo "mysql_charset=utf8" >> autoinstall.ini
	echo "http_server=apache" >> autoinstall.ini
	echo "ispconfig_port=8080" >> autoinstall.ini
	echo "ispconfig_use_ssl=y" >> autoinstall.ini
	echo "ispconfig_admin_password=admin" >> autoinstall.ini
	echo
	echo "[ssl_cert]" >> autoinstall.ini
	echo "ssl_cert_country=$SSL_COUNTRY" >> autoinstall.ini
    echo "ssl_cert_state=$SSL_STATE" >> autoinstall.ini
	echo "ssl_cert_locality=$SSL_LOCALITY" >> autoinstall.ini
	echo "ssl_cert_organisation=$SSL_ORGANIZATION" >> autoinstall.ini
	echo "ssl_cert_organisation_unit=$SSL_ORGUNIT" >> autoinstall.ini
	echo "ssl_cert_common_name=$CFG_HOSTNAME_FQDN" >> autoinstall.ini
	echo
	echo "[expert]" >> autoinstall.ini
	echo "mysql_ispconfig_user=ispconfig" >> autoinstall.ini
	echo "mysql_ispconfig_password=afStEratXBsgatRtsa42CadwhQ" >> autoinstall.ini
	echo "join_multiserver_setup=$MULTISERVER" >> autoinstall.ini
    echo "mysql_master_hostname=$CFG_MASTER_FQDN" >> autoinstall.ini
	echo "mysql_master_root_user=root" >> autoinstall.ini
	echo "mysql_master_root_password=$CFG_MASTER_MYSQL_ROOT_PWD" >> autoinstall.ini
	echo "mysql_master_database=dbispconfig" >> autoinstall.ini
	echo "configure_mail=y" >> autoinstall.ini
    echo "configure_jailkit=y" >> autoinstall.ini
    echo "configure_ftp=y" >> autoinstall.ini
	echo "configure_dns=y" >> autoinstall.ini
    echo "configure_apache=y" >> autoinstall.ini
	echo "configure_nginx=y" >> autoinstall.ini
	echo "configure_firewall=y" >> autoinstall.ini
	echo "install_ispconfig_web_interface=$CFG_SETUP_MASTER" >> autoinstall.ini
	echo
	echo "[update]" >> autoinstall.ini
	echo "do_backup=yes" >> autoinstall.ini
	echo "mysql_root_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
    echo "mysql_master_hostname=$CFG_MASTER_FQDN" >> autoinstall.ini
	echo "mysql_master_root_user=root" >> autoinstall.ini
    echo "mysql_master_root_password=$CFG_MASTER_MYSQL_ROOT_PWD" >> autoinstall.ini
	echo "mysql_master_database=dbispconfig" >> autoinstall.ini
	echo "reconfigure_permissions_in_master_database=no" >> autoinstall.ini
	echo "reconfigure_services=yes" >> autoinstall.ini
    echo "ispconfig_port=8080" >> autoinstall.ini
	echo "create_new_ispconfig_ssl_cert=no" >> autoinstall.ini
    echo "reconfigure_crontab=yes" >> autoinstall.ini
    echo | php -q install.php --autoinstall=autoinstall.ini

# ISPConfig Install Finish
	echo -e "${green}Well done! ISPConfig installed and configured correctly :) ${NC}"
	echo "Now you can connect to your ISPConfig installation at https://$CFG_HOSTNAME_FQDN:8080 or https://IP_ADDRESS:8080"

}