# Ask Question Single Server
AskQuestionsSingleServer() {
    echo "Please enter the information required for installation."

    while [ "x$CFG_HOSTNAME_FQDN" == "x" ]
        do
            CFG_HOSTNAME_FQDN=$(whiptail --title "HOSTNAME" --backtitle "$WT_BACKTITLE" --inputbox "Please specify Server Hostname" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

    while [ "x$CFG_MYSQL_ROOT_PWD" == "x" ]
        do
            CFG_MYSQL_ROOT_PWD=$(whiptail --title "MySQL" --backtitle "$WT_BACKTITLE" --inputbox "Please specify a root password" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

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

    while [ "x$SSL_COUNTRY" == "x" ]
        do
            SSL_COUNTRY=$(whiptail --title "SSL Country" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Country (ex. EN)" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

    while [ "x$SSL_STATE" == "x" ]
        do
            SSL_STATE=$(whiptail --title "SSL State" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - STATE (ex. Italy)" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

    while [ "x$SSL_LOCALITY" == "x" ]
        do
            SSL_LOCALITY=$(whiptail --title "SSL Locality" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Locality (ex. Udine)" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

    while [ "x$SSL_ORGANIZATION" == "x" ]
        do
            SSL_ORGANIZATION=$(whiptail --title "SSL Organization" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Organization (ex. Company L.t.d.)" --nocancel 10 50 3>&1 1>&2 2>&3)
        done

    while [ "x$SSL_ORGUNIT" == "x" ]
        do
            SSL_ORGUNIT=$(whiptail --title "SSL Organization Unit" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Organization Unit (ex. IT Department)" --nocancel 10 50 3>&1 1>&2 2>&3)
        done
}