#!/bin/bash
#
# Ubuntu 16.04 ISPConfig 3 Standard(Single Server) Automation Script
# Install Manual : https://www.howtoforge.com/tutorial/perfect-server-ubuntu-16.04-with-apache-php-myqsl-pureftpd-bind-postfix-doveot-and-ispconfig/
# Create Date : 2017-10-27
# Made by ysyuk910
#

# Loging
exec > >(tee -i /var/log/ispconfig_setup.log)
exec 2>&1

# Global variables
#   CFG_HOSTNAME_FQDN=`hostname -f`;
    WT_BACKTITLE="ISPConfig 3 System Installer by KSCloud"

# Bash Color
    red='\033[0;31m'
    green='\033[0;32m'
    NC='\033[0m' # No Color

# Setting Questions
    CFG_HOSTNAME_FQDN=$(whiptail --title "HOSTNAME" --backtitle "$WT_BACKTITLE" --inputbox "Please specify Server Hostname" --nocancel 10 50 3>&1 1>&2 2>&3)
    CFG_MYSQL_ROOT_PWD=$(whiptail --title "MySQL" --backtitle "$WT_BACKTITLE" --inputbox "Please specify a root password" --nocancel 10 50 3>&1 1>&2 2>&3)
    MMLISTOWNER=$(whiptail --title "Mailman Site List Owner" --backtitle "$WT_BACKTITLE" --inputbox "Please specify the Mailman site list owner ex:example@example.com" --nocancel 10 50 3>&1 1>&2 2>&3)
	MMLISTPASS=$(whiptail --title "Mailman Site List Password" --backtitle "$WT_BACKTITLE" --inputbox "Please specify the Mailman site list password" --nocancel 10 50 3>&1 1>&2 2>&3)
	ROUNDCUBE_PWD=$(whiptail --title "ROUNDCUBE Database Name" --backtitle "$WT_BACKTITLE" --inputbox "Please specify the roundcube pasword" --nocancel 10 50 3>&1 1>&2 2>&3)
    SSL_COUNTRY=$(whiptail --title "SSL Country" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Country (ex. EN)" --nocancel 10 50 3>&1 1>&2 2>&3)
    SSL_STATE=$(whiptail --title "SSL State" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - STATE (ex. Italy)" --nocancel 10 50 3>&1 1>&2 2>&3)
    SSL_LOCALITY=$(whiptail --title "SSL Locality" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Locality (ex. Udine)" --nocancel 10 50 3>&1 1>&2 2>&3)
    SSL_ORGANIZATION=$(whiptail --title "SSL Organization" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Organization (ex. Company L.t.d.)" --nocancel 10 50 3>&1 1>&2 2>&3)
    SSL_ORGUNIT=$(whiptail --title "SSL Organization Unit" --backtitle "$WT_BACKTITLE" --inputbox "SSL Configuration - Organization Unit (ex. IT Department)" --nocancel 10 50 3>&1 1>&2 2>&3)

# hostname
    echo -n "Setting Hostname..."
    echo "127.0.0.1   $CFG_HOSTNAME_FQDN localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/hosts
    echo -e "[${green}DONE${NC}]\n"

# AppArmor
    echo -n "Disable AppArmor..."
    service apparmor stop > /dev/null 2>&1
    update-rc.d -f apparmor remove 
    apt-get -yqq remove apparmor apparmor-utils > /dev/null 2>&1
    echo -e "[${green}DONE${NC}]\n"

# System Clock
    echo -n "System Clock Setting..."
    apt-get -yqq install ntp ntpdate > /dev/null 2>&1
    echo -e "[${green}DONE${NC}]\n"

# Postfix, Dovecot, MariaDB, rkhunter and binutils
    echo -n "Postfix, Dovecot, MariaDB, rkhunter and binutils install..."
    service sendmail stop; update-rc.d -f sendmail remove > /dev/null 2>&1
    echo "mysql-server-5.7 mysql-server/root_password password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    echo "mysql-server-5.7 mysql-server/root_password_again password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
    echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
    echo "postfix postfix/mailname string $CFG_HOSTNAME_FQDN" | debconf-set-selections
    apt-get -yqq install postfix postfix-mysql postfix-doc mysql-server mysql-client openssl getmail4 rkhunter binutils dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-sieve dovecot-lmtpd sudo  > /dev/null 2>&1

    sed -i "s/#submission inet n       -       y       -       -       smtpd/submission inet n       -       y       -       -       smtpd/" /etc/postfix/master.cf
    sed -i "s/#  -o syslog_name=postfix\/submission/  -o syslog_name=postfix\/submission/" /etc/postfix/master.cf
    sed -i "s/#  -o smtpd_tls_security_level=encrypt/  -o smtpd_tls_security_level=encrypt/" /etc/postfix/master.cf
    sed -i "s/#  -o smtpd_sasl_auth_enable=yes/  -o smtpd_sasl_auth_enable=yes\n  -o smtpd_client_restrictions=permit_sasl_authenticated,reject/" /etc/postfix/master.cf
    sed -i "s/#smtps     inet  n       -       y       -       -       smtpd/smtps     inet  n       -       y       -       -       smtpd/" /etc/postfix/master.cf
    sed -i "s/#  -o syslog_name=postfix\/smtps/  -o syslog_name=postfix\/smtps/" /etc/postfix/master.cf
    sed -i "s/#  -o smtpd_tls_wrappermode=yes/  -o smtpd_tls_wrappermode=yes/" /etc/postfix/master.cf
    sed -i "s/#  -o smtpd_sasl_auth_enable=yes/  -o smtpd_sasl_auth_enable=yes\n  -o smtpd_client_restrictions=permit_sasl_authenticated,reject/" /etc/postfix/master.cf
    service postfix restart > /dev/null 2>&1

    sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/mysql.conf.d/mysqld.cnf
	echo "sql-mode=\"NO_ENGINE_SUBSTITUTION\"" >> /etc/mysql/mysql.conf.d/mysqld.cnf
    service mysql restart > /dev/null 2>&1

    echo -e "[${green}DONE${NC}]\n"

# Amavisd-new, SpamAssassin, and Clamav
    echo -n "Amavisd-new, SpamAssassin, and Clamav install..."
    apt-get -yqq install amavisd-new spamassassin clamav clamav-daemon zoo unzip bzip2 arj nomarch lzop cabextract apt-listchanges libnet-ldap-perl libauthen-sasl-perl clamav-docs daemon libio-string-perl libio-socket-ssl-perl libnet-ident-perl zip libnet-dns-perl postgrey > /dev/null 2>&1
    service spamassassin stop > /dev/null 2>&1
    update-rc.d -f spamassassin remove
    sed -i "s/AllowSupplementaryGroups false/AllowSupplementaryGroups true/" /etc/clamav/clamd.conf
    freshclam
    service clamav-daemon start > /dev/null 2>&1
    echo -e "[${green}DONE${NC}]\n"

# Apache, PHP, FCGI, SuExec, Pear, and mcrypt
    echo -n "Apache, PHP, phpMyAdmin, FCGI, SuExec, Pear, and mcrypt install..."
    echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
    echo "dbconfig-common dbconfig-common/dbconfig-install boolean false" | debconf-set-selections
    echo "phpmyadmin phpmyadmin/dbconfig-install boolean false" | debconf-set-selections
    apt-get -yqq install apache2 apache2-doc apache2-utils  phpmyadmin libapache2-mod-fastcgi libapache2-mod-php php7.0 php7.0-common php7.0-fpm php7.0-gd php7.0-mysql php7.0-imap phpmyadmin php7.0-cli php7.0-cgi libapache2-mod-fcgid apache2-suexec-pristine php-pear php-auth php7.0-mcrypt mcrypt  imagemagick libruby libapache2-mod-python php7.0-curl php7.0-intl php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl memcached php-memcache php-imagick php-gettext php7.0-zip php7.0-mbstring php7.0-opcache php-apcu > /dev/null 2>&1
   
	a2enmod suexec > /dev/null 2>&1
	a2enmod rewrite > /dev/null 2>&1
	a2enmod ssl > /dev/null 2>&1
	a2enmod actions > /dev/null 2>&1
	a2enmod include > /dev/null 2>&1
    a2enmod cgi > /dev/null 2>&1
	a2enmod dav_fs > /dev/null 2>&1
	a2enmod dav > /dev/null 2>&1
	a2enmod auth_digest > /dev/null 2>&1
    a2enmod headers > /dev/null 2>&1
	a2enmod fastcgi > /dev/null 2>&1
	a2enmod alias > /dev/null 2>&1
	a2enmod fcgid > /dev/null 2>&1
	a2enconf httpoxy > /dev/null 2>&1
	service apache2 restart > /dev/null 2>&1

    echo "<IfModule mod_headers.c>
    RequestHeader unset Proxy early
	</IfModule>" | tee /etc/apache2/conf-available/httpoxy.conf > /dev/null 2>&1

    service apache2 restart > /dev/null 2>&1
    echo -e "[${green}DONE${NC}]\n"

# HHVM
    echo -n "HHVM install..."
    apt-get -yqq install software-properties-common > /dev/null 2>&1
    apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 > /dev/null 2>&1
    add-apt-repository "deb http://dl.hhvm.com/ubuntu xenial main" > /dev/null 2>&1
    apt-get -yqq install hhvm > /dev/null 2>&1
    echo -e "[${green}DONE${NC}]\n"

# Let's Encrypt
    echo -n "Let's Encrypt install..."
    apt-get -y install letsencrypt > /dev/null 2>&1
    echo -e "[${green}DONE${NC}]\n"

# Mailman
    echo -n "Mailman install..."
    echo "mailman mailman/site_languages multiselect en ko" | debconf-set-selections
    echo "mailman mailman/default_server_language en" | debconf-set-selections
    echo "mailman mailman/used_languages en" | debconf-set-selections
    echo "postfix postfix/main_mailer_type select Internet Site" | debconf-set-selections
    echo "postfix postfix/mailname string $CFG_HOSTNAME_FQDN" | debconf-set-selections
    apt-get -yqq install mailman
    newlist -q mailman ${MMLISTOWNER} ${MMLISTPASS}

    echo "## mailman mailing list" >> /etc/aliases
    echo "mailman:              \"|/var/lib/mailman/mail/mailman post mailman\"" >> /etc/aliases
    echo "mailman-admin:        \"|/var/lib/mailman/mail/mailman admin mailman\"" >> /etc/aliases
    echo "mailman-bounces:      \"|/var/lib/mailman/mail/mailman bounces mailman\"" >> /etc/aliases
    echo "mailman-confirm:      \"|/var/lib/mailman/mail/mailman confirm mailman\"" >> /etc/aliases
    echo "mailman-join:         \"|/var/lib/mailman/mail/mailman join mailman\"" >> /etc/aliases
    echo "mailman-leave:        \"|/var/lib/mailman/mail/mailman leave mailman\"" >> /etc/aliases
    echo "mailman-owner:        \"|/var/lib/mailman/mail/mailman owner mailman\"" >> /etc/aliases
    echo "mailman-request:      \"|/var/lib/mailman/mail/mailman request mailman\"" >> /etc/aliases
    echo "mailman-subscribe:    \"|/var/lib/mailman/mail/mailman subscribe mailman\"" >> /etc/aliases
    echo "mailman-unsubscribe:  \"|/var/lib/mailman/mail/mailman unsubscribe mailman\"" >> /etc/aliases

    newaliases
    service postfix restart > /dev/null 2>&1
    ln -s /etc/mailman/apache.conf /etc/apache2/conf-available/mailman.conf
    service apache2 restart > /dev/null 2>&1
    service mailman start > /dev/null 2>&1
    echo -e "[${green}DONE${NC}]\n"

# PureFTPd and Quota
    echo -n "PureFTPd and Quota install..."
    apt-get -yqq install pure-ftpd-common pure-ftpd-mysql quota quotatool > /dev/null 2>&1
    sed -i "s/VIRTUALCHROOT=false/VIRTUALCHROOT=true/" /etc/default/pure-ftpd-common
    echo 1 > /etc/pure-ftpd/conf/TLS
    mkdir -p /etc/ssl/private/
    openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -subj "/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORGANIZATION/OU=$SSL_ORGUNIT/CN=$CFG_HOSTNAME_FQDN"
    chmod 600 /etc/ssl/private/pure-ftpd.pem
    service pure-ftpd-mysql restart > /dev/null 2>&1
    sed -i 's/errors=remount-ro/errors=remount-ro,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0/' /etc/fstab
    mount -o remount /
    echo -e "[${green}DONE${NC}]\n"

# Bind
    echo -n "Bind install..."
    apt-get -yqq install bind9 dnsutils haveged
    echo -e "[${green}DONE${NC}]\n"

# Vlogger, Webalizer, and AWstats
    echo -n "Vlogger, Webalizer, and AWstats install..."
    apt-get -yqq install vlogger webalizer awstats geoip-database libclass-dbi-mysql-perl > /dev/null 2>&1 
    sed -i 's/^/#/' /etc/cron.d/awstats
    echo -e "[${green}DONE${NC}]\n"

# Jailkit
    echo -n "Jailkit install... "
    cd /usr/local/src
    wget http://olivier.sessink.nl/jailkit/jailkit-2.19.tar.gz > /dev/null 2>&1 
    tar xvfz jailkit-2.19.tar.gz
    cd jailkit-2.19
    ./debian/rules binary > /dev/null 2>&1
    cd ..
    dpkg -i jailkit_2.19-1_*.deb > /dev/null 2>&1
    echo -e "${green}done! ${NC}\n"

# fail2ban and UFW
    echo -n "fail2ban and UFW install... "
    apt-get -yqq install fail2ban > /dev/null 2>&1

    echo "[pureftpd]" >> /etc/fail2ban/jail.local
    echo "enabled  = true" >> /etc/fail2ban/jail.local
    echo "port     = ftp" >> /etc/fail2ban/jail.local
    echo "filter   = pureftpd" >> /etc/fail2ban/jail.local
    echo "logpath  = /var/log/syslog" >> /etc/fail2ban/jail.local
    echo "maxretry = 3" >> /etc/fail2ban/jail.local

    echo "[dovecot-pop3imap]" >> /etc/fail2ban/jail.local
    echo "enabled = true" >> /etc/fail2ban/jail.local
    echo "filter = dovecot-pop3imap" >> /etc/fail2ban/jail.local
    echo "action = iptables-multiport[name=dovecot-pop3imap, port="pop3,pop3s,imap,imaps", protocol=tcp]" >> /etc/fail2ban/jail.local
    echo "logpath = /var/log/mail.log" >> /etc/fail2ban/jail.local
    echo "maxretry = 5" >> /etc/fail2ban/jail.local

    echo "[postfix-sasl]" >> /etc/fail2ban/jail.local
    echo "enabled  = true" >> /etc/fail2ban/jail.local
    echo "port     = smtp" >> /etc/fail2ban/jail.local
    echo "filter   = postfix-sasl" >> /etc/fail2ban/jail.local
    echo "logpath  = /var/log/mail.log" >> /etc/fail2ban/jail.local
    echo "maxretry = 3" >> /etc/fail2ban/jail.local

    echo "[Definition]" >> /etc/fail2ban/filter.d/pureftpd.conf
    echo "failregex = .*pure-ftpd: \(.*@<HOST>\) \[WARNING\] Authentication failed for user.*"  >> /etc/fail2ban/filter.d/pureftpd.conf
    echo "ignoreregex =" >> /etc/fail2ban/filter.d/pureftpd.conf

    echo "[Definition]" >> /etc/fail2ban/filter.d/dovecot-pop3imap.conf
    echo "failregex = (?: pop3-login|imap-login): .*(?:Authentication failure|Aborted login \(auth failed|Aborted login \(tried to use disabled|Disconnected \(auth failed|Aborted login \(\d+ authentication attempts).*rip=(?P<host>\S*),.*"  >> /etc/fail2ban/filter.d/dovecot-pop3imap.conf
    echo "ignoreregex ="  >> /etc/fail2ban/filter.d/dovecot-pop3imap.conf
    echo "ignoreregex =" >> /etc/fail2ban/filter.d/postfix-sasl.conf

    service fail2ban restart > /dev/null 2>&1
    apt-get -yqq install ufw > /dev/null 2>&1
    echo -e "${green}done! ${NC}\n"

# Roundcube Webmail
    echo -n "Roundcube Webmail install... "
	echo "roundcube-core roundcube/dbconfig-install boolean true" | debconf-set-selections
	echo "roundcube-core roundcube/database-type select mysql" | debconf-set-selections
	echo "roundcube-core roundcube/mysql/admin-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
	echo "roundcube-core roundcube/db/dbname string roundcube" | debconf-set-selections
	echo "roundcube-core roundcube/mysql/app-pass password $CFG_ROUNDCUBE_PWD" | debconf-set-selections
	echo "roundcube-core roundcube/app-password-confirm password $CFG_ROUNDCUBE_PWD" | debconf-set-selections
	echo "roundcube-core rjrwjderoundcube/hosts string localhost" | debconf-set-selections
    apt-get -yqq install roundcube roundcube-core roundcube-mysql roundcube-plugins roundcube-plugins-extra javascript-common libjs-jquery-mousewheel php-net-sieve tinymce  > /dev/null 2>&1

    sed -i 's/\#    Alias \/roundcube \/var\/lib\/roundcube/    Alias \/roundcube \/var\/lib\/roundcube/' /etc/apache2/conf-enabled/roundcube.conf
    sed -i '/Options +FollowSymLinks/i\AddType application\/x-httpd-php .php' /etc/apache2/conf-enabled/roundcube.conf
    sed -i "s/host'] = '';/host'] = 'localhost';/" /etc/roundcube/config.inc.php
    service apache2 restart > /dev/null 2>&1
    echo -e "${green}done! ${NC}\n"

# ISPConfig
    echo -n "Installing ISPConfig... "
    cd /usr/local/src
    wget https://www.ispconfig.org/downloads/ISPConfig-3-stable.tar.gz
    tar xfz ISPConfig-3-stable.tar.gz
    cd ispconfig3_install/install/
    echo "Create INI file"
    touch autoinstall.ini
    echo "[install]" > autoinstall.ini
    echo "language=en" >> autoinstall.ini
    echo "install_mode=standard" >> autoinstall.ini
    echo "hostname=$CFG_HOSTNAME_FQDN" >> autoinstall.ini
    echo "mysql_hostname=localhost" >> autoinstall.ini
    echo "mysql_root_user=root" >> autoinstall.ini
    echo "mysql_root_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
    echo "mysql_database=dbispconfig" >> autoinstall.ini
    echo "mysql_charset=utf8" >> autoinstall.ini
    echo "http_server=apache" >> autoinstall.ini
    echo "ispconfig_port=8080" >> autoinstall.ini
    echo "ispconfig_use_ssl=y" >> autoinstall.ini
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
    echo "join_multiserver_setup=n" >> autoinstall.ini
    echo "mysql_master_hostname=master.example.com" >> autoinstall.ini
    echo "mysql_master_root_user=root" >> autoinstall.ini
    echo "mysql_master_root_password=ispconfig" >> autoinstall.ini
    echo "mysql_master_database=dbispconfig" >> autoinstall.ini
    echo "configure_mail=y" >> autoinstall.ini
    echo "configure_jailkit=y" >> autoinstall.ini
    echo "configure_ftp=y" >> autoinstall.ini
    echo "configure_dns=y" >> autoinstall.ini
    echo "configure_apache=y" >> autoinstall.ini
    echo "configure_nginx=n" >> autoinstall.ini
    echo "configure_firewall=y" >> autoinstall.ini
    echo "install_ispconfig_web_interface=y" >> autoinstall.ini
    echo
    echo "[update]" >> autoinstall.ini
    echo "do_backup=yes" >> autoinstall.ini
    echo "mysql_root_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
    echo "mysql_master_hostname=master.example.com" >> autoinstall.ini
    echo "mysql_master_root_user=root" >> autoinstall.ini
    echo "mysql_master_root_password=ispconfig" >> autoinstall.ini
    echo "mysql_master_database=dbispconfig" >> autoinstall.ini
    echo "reconfigure_permissions_in_master_database=no" >> autoinstall.ini
    echo "reconfigure_services=yes" >> autoinstall.ini
    echo "ispconfig_port=8080" >> autoinstall.ini
    echo "create_new_ispconfig_ssl_cert=no" >> autoinstall.ini
    echo "reconfigure_crontab=yes" >> autoinstall.ini
    echo | php -q install.php --autoinstall=autoinstall.ini

# ISPConfig Install Finish
	echo -e "${green}Well done! ISPConfig installed and configured correctly :D ${NC}"
	echo "Now you can connect to your ISPConfig installation at https://$CFG_HOSTNAME_FQDN:8080 or https://IP_ADDRESS:8080"