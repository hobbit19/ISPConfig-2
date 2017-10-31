# Ask Question Multi Server
AskQuestionsMultiServer() {
    echo "Please enter the information required for installation."

    while [ "x$CFG_HOSTNAME_FQDN" == "x" ]
        do
            CFG_HOSTNAME_FQDN=$(whiptail --title "HOSTNAME" --backtitle "$WT_BACKTITLE" --inputbox "Please specify Server Hostname" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

    while [ "x$CFG_MYSQL_ROOT_PWD" == "x" ]
        do
            CFG_MYSQL_ROOT_PWD=$(whiptail --title "MySQL" --backtitle "$WT_BACKTITLE" --inputbox "Please specify a root password" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

    if [ $CFG_SETUP_MASTER == "n" ]; then
        while [ "x$CHECK_MASTER_CONNECTION" == "x" ]
		do
		  while [ "x$CFG_MASTER_FQDN" == "x" ]
		  do
		  CFG_MASTER_FQDN=$(whiptail --title "MySQL" --backtitle "$WT_BACKTITLE" --inputbox "Please specify the master FQDN" --nocancel 10 50 3>&1 1>&2 2>&3)
		  done

		  while [ "x$CFG_MASTER_MYSQL_ROOT_PWD" == "x" ]
		  do
		  CFG_MASTER_MYSQL_ROOT_PWD=$(whiptail --title "MySQL" --backtitle "$WT_BACKTITLE" --inputbox "Please specify the master root password" --nocancel 10 50 3>&1 1>&2 2>&3)
		  done

		  text="Before continue, you got to lunch the following SQL commands on your master server

		  CREATE USER 'root'@'$(ping -c1 $(hostname) | grep icmp_seq | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')' IDENTIFIED BY '$CFG_MASTER_MYSQL_ROOT_PWD';

		  GRANT ALL PRIVILEGES ON * . * TO 'root'@'$(ping -c1 $(hostname) | grep icmp_seq | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')' IDENTIFIED BY '$CFG_MASTER_MYSQL_ROOT_PWD' WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;

		  CREATE USER 'root'@'$(hostname)' IDENTIFIED BY '$CFG_MASTER_MYSQL_ROOT_PWD';

		  GRANT ALL PRIVILEGES ON * . * TO 'root'@'$(hostname)' IDENTIFIED BY '$CFG_MASTER_MYSQL_ROOT_PWD' WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;

		  Press "OK" when done
		  "

		  whiptail --title "MySQL command on Master Server" --msgbox "$text" 25 90
		  MULTISERVER=y

		  if mysql --user=root --password=$CFG_MASTER_MYSQL_ROOT_PWD --host=$CFG_MASTER_FQDN --execute="\q" ; then
			CHECK_MASTER_CONNECTION=true		# If variable is empty, then the connection when fine, so we set true to exit from cycle
		  else
			text="Sorry but you cant connect to Master mysql server

			- Check to had run the mysql command to allow remote connection
			- Check FQDN is correct
			- Check root MySQL password is correct"

			whiptail --title "MySQL Master Connection Failed" --msgbox "$text" 25 90
		  fi
	    done
    fi

    while [ "x$MMLISTOWNER" == "x" ]
        do
            MMLISTOWNER=$(whiptail --title "Mailman Site List Owner" --backtitle "$WT_BACKTITLE" --inputbox "Please specify the Mailman site list owner ex:example@example.com" --nocancel 10 50 3>&1 1>&2 2>&3)
        done
    
    while [ "x$MMLISTPASS" == "x" ]
        do
            MMLISTPASS=$(whiptail --title "Mailman Site List Password" --backtitle "$WT_BACKTITLE" --inputbox "Please specify the Mailman site list password" --nocancel 10 50 3>&1 1>&2 2>&3)
        done
    
    while [ "x$ROUNDCUBE_DB" == "x" ]
        do
            ROUNDCUBE_DB=$(whiptail --title "ROUNDCUBE Database Name" --backtitle "$WT_BACKTITLE" --inputbox "Please specify the roundcube database name" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

    while [ "x$ROUNDCUBE_USER" == "x" ]
        do
            ROUNDCUBE_USER=$(whiptail --title "ROUNDCUBE Database User" --backtitle "$WT_BACKTITLE" --inputbox "Please specify the roundcube database user" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

    while [ "x$ROUNDCUBE_PWD" == "x" ]
        do
            ROUNDCUBE_PWD=$(whiptail --title "ROUNDCUBE Database Name" --backtitle "$WT_BACKTITLE" --inputbox "Please specify the roundcube pasword" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

            SSL_COUNTRY=$(whiptail --title "SSL Country" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Country (ex. EN)" --nocancel 10 50 3>&1 1>&2 2>&3)
            SSL_STATE=$(whiptail --title "SSL State" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - STATE (ex. Italy)" --nocancel 10 50 3>&1 1>&2 2>&3)
            SSL_LOCALITY=$(whiptail --title "SSL Locality" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Locality (ex. Udine)" --nocancel 10 50 3>&1 1>&2 2>&3)
            SSL_ORGANIZATION=$(whiptail --title "SSL Organization" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Organization (ex. Company L.t.d.)" --nocancel 10 50 3>&1 1>&2 2>&3)
            SSL_ORGUNIT=$(whiptail --title "SSL Organization Unit" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Organization Unit (ex. IT Department)" --nocancel 10 50 3>&1 1>&2 2>&3)

}