# CentOS 7 ISPConfig 3 Standard(Single Server) Automation Script
# Install Manual : https://www.howtoforge.com/tutorial/perfect-server-centos-7-3-apache-mysql-php-pureftpd-postfix-dovecot-and-ispconfig
# CentOS 7 버전용 ISPConfig 기본설치 스크립트.
# 설치 매뉴얼에 따라 자동설치되록 설정

InstallCentOSServer() {
# hostname
    #echo -n "Setting Hostname..."
    echo "127.0.0.1   $CFG_HOSTNAME_FQDN localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/hosts
    echo "::1         $CFG_HOSTNAME_FQDN localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
    #echo -e "${green}done${NC}"

# EPEL & Development Tools
    #echo -n "EPEL repo & Development Tools install..."
    yum -y install epel-release #> /dev/null 2>&1
    yum -y groupinstall 'Development Tools' #> /dev/null 2>&1
    #echo -e "${green}done${NC}"

# Quota
    #echo -n "Quota install..."
    yum -y install quota #> /dev/null 2>&1
    sed -i "s/GRUB_CMDLINE_LINUX=\"rhgb quiet\"/GRUB_CMDLINE_LINUX=\"rhgb quiet rootflags=uquota,gquota\"/" /etc/default/grub
    cp /boot/grub2/grub.cfg /boot/grub2/grub.cfg_bak
    grub2-mkconfig -o /boot/grub2/grub.cfg
    #echo -e "${green}done${NC}"

# Apache, MySQL, phpMyAdmin
    #echo -n "Apache, MySQL, phpMyAdmin install and setting..."
    yum -y install ntp httpd mod_ssl mariadb-server php php-mysql php-mbstring phpmyadmin expect #> /dev/null 2>&1
    echo "RequestHeader unset Proxy early" >> /etc/httpd/conf/httpd.conf
    systemctl enable httpd #> /dev/null 2>&1
    systemctl start httpd #> /dev/null 2>&1
    systemctl enalbe mariadb #> /dev/null 2>&1
    systemctl start mariadb #> /dev/null 2>&1

# MySQL(MariaDB) root password
    SECURE_MYSQL=$(expect -c "
        set timeout 3
        spawn mysql_secure_installation
        expect \"Enter current password for root (enter for none):\"
        send \"\r\"
        expect \"root password?\"
        send \"y\r\"
        expect \"New password:\"
        send \"$CFG_MYSQL_ROOT_PWD\r\"
        expect \"Re-enter new password:\"
        send \"$CFG_MYSQL_ROOT_PWD\r\"
        expect \"Remove anonymous users?\"
        send \"y\r\"
        expect \"Disallow root login remotely?\"
        send \"y\r\"
        expect \"Remove test database and access to it?\"
        send \"y\r\"
        expect \"Reload privilege tables now?\"
        send \"y\r\"
        expect eof
    ")
    echo "${SECURE_MYSQL}"
    
# phpMyAdmin Config
    sed -i "s/Require ip 127.0.0.1/#Require ip 127.0.0.1/" /etc/httpd/conf.d/phpMyAdmin.conf
    sed -i '0,/Require ip ::1/ s/Require ip ::1/#Require ip ::1\n       Require all granted/' /etc/httpd/conf.d/phpMyAdmin.conf
    sed -i "s/'cookie'/'http'/" /etc/phpMyAdmin/config.inc.php
    systemctl restart httpd  #> /dev/null 2>&1
    #echo -e "${green}done${NC}"

# Dovecot
    #echo -n "Dovecot install..."
    yum -y install dovecot dovecot-mysql dovecot-pigeonhole #> /dev/null 2>&1
    touch /etc/dovecot/dovecot-sql.conf
    ln -s /etc/dovecot/dovecot-sql.conf /etc/dovecot-sql.conf
    ln -s /etc/dovecot/dovecot.conf /etc/dovecot.conf
    systemctl enable dovecot #> /dev/null 2>&1
    systemctl start dovecot #> /dev/null 2>&1
    #echo -e "${green}done${NC}"

# Postfix
    #echo -n "Postfix install..."
    yum -y install postfix #> /dev/null 2>&1
    systemctl stop sendmail #> /dev/null 2>&1
    systemctl disable sendmail #> /dev/null 2>&1
    systemctl enable postfix #> /dev/null 2>&1
    systemctl restart postfix #> /dev/null 2>&1
    #echo -e "${green}done${NC}"

# Getmail
    #echo -n "Getmail install..."
    yum -y install getmail #> /dev/null 2>&1
    #echo -e "${green}done${NC}"

# Amavisd-new, SpamAssassin, ClamAV, and Postgrey
    #echo -n "Amavisd-new, SpamAssassin, ClamAV, and Postgrey install..."
    yum -y install amavisd-new spamassassin clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd unzip bzip2 perl-DBD-mysql postgrey re2c #> /dev/null 2>&1
    sa-update #> /dev/null 2>&1
    freshclam #> /dev/null 2>&1
    systemctl enable amavisd #> /dev/null 2>&1
    systemctl start amavisd #> /dev/null 2>&1
    systemctl start clamd@amavisd #> /dev/null 2>&1
    systemctl enable postgrey #> /dev/null 2>&1
    systemctl start postgrey #> /dev/null 2>&1
    #echo -e "${green}done${NC}"

# Apache with mod_php, mod_fcgi/PHP5, PHP-FPM
    #echo -n "Apache with mod_php, mod_fcgi/PHP5, PHP-FPM install..."
    yum -y install php php-devel php-gd php-imap php-ldap php-mysql php-odbc php-pear php-xml php-xmlrpc php-pecl-apc php-mbstring php-mcrypt php-mssql php-snmp php-soap php-tidy curl curl-devel perl-libwww-perl ImageMagick libxml2 libxml2-devel mod_fcgid php-cli httpd-devel php-fpm wget #> /dev/null 2>&1
	sed -i "s/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/error_reporting = E_ALL \& ~E_NOTICE \& ~E_DEPRECATED/" /etc/php.ini
	sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/" /etc/php.ini
	sed -i "s/;date.timezone =/date.timezone = 'Asia\/Seoul'/" /etc/php.ini
    systemctl start php-fpm #> /dev/null 2>&1
    systemctl enable php-fpm #> /dev/null 2>&1
    systemctl restart httpd #> /dev/null 2>&1
    #echo -e "${green}done${NC}"

# Certbot
    #echo -n "Installing Certbot... "
    mkdir /usr/local/src/certbot
    cd /usr/local/src/certbot
    wget https://dl.eff.org/certbot-auto
    chmod a+x ./certbot-auto
    CERT_BOT=$(expect -c "
        set timeout 20
        spawn /usr/local/src/certbot/certbot-auto
        expect \"name(s) (comma and/or space separated) (Enter 'c' to cancel):\"
        send \"c\r\"
        expect eof
    ")
    echo "${CERT_BOT}"
    #echo -e "${green}done! ${NC}\n"

# mod_python
    #echo -n "Installing mod_python... "
    yum -y install python-devel #> /dev/null 2>&1
    cd /usr/local/src/
    wget http://dist.modpython.org/dist/mod_python-3.5.0.tgz
    tar xfz mod_python-3.5.0.tgz
    cd mod_python-3.5.0
    ./configure
    make -j `cat /proc/cpuinfo | grep cores | wc -l `
    make install
    echo 'LoadModule python_module modules/mod_python.so' > /etc/httpd/conf.modules.d/10-python.conf
    systemctl restart httpd
    #echo -e "${green}done! ${NC}\n"

# PureFTPd
    #echo -n "Installing PureFTPd... "
    yum -y install pure-ftpd #> /dev/null 2>&1
    systemctl enable pure-ftpd #> /dev/null 2>&1
    systemctl start pure-ftpd #> /dev/null 2>&1
    yum -y install openssl #> /dev/null 2>&1
    sed -i "s/\#TLS                      1/TLS                      1/" /etc/pure-ftpd/pure-ftpd.conf
    mkdir -p /etc/ssl/private/
    openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem -subj "/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORGANIZATION/OU=$SSL_ORGUNIT/CN=$CFG_HOSTNAME_FQDN"
    chmod 600 /etc/ssl/private/pure-ftpd.pem
    systemctl restart pure-ftpd #> /dev/null 2>&1
    #echo -e "${green}done! ${NC}\n"

# BIND
    #echo -n "Installing BIND... "
    yum -y install bind bind-utils haveged #> /dev/null 2>&1
    cp /etc/named.conf /etc/named.conf_bak
    cat /dev/null > /etc/named.conf
    echo "//" >> /etc/named.conf
    echo "// named.conf" >> /etc/named.conf
    echo "//" >> /etc/named.conf
    echo "// Provided by Red Hat bind package to configure the ISC BIND named(8) DNS"  >> /etc/named.conf
    echo "// server as a caching only nameserver (as a localhost DNS resolver only)."  >> /etc/named.conf
    echo "//"  >> /etc/named.conf
    echo "// See /usr/share/doc/bind*/sample/ for example named configuration files."  >> /etc/named.conf
    echo "//"  >> /etc/named.conf
    echo "options {"  >> /etc/named.conf
    echo "        listen-on port 53 { any; };" >> /etc/named.conf
    echo "        listen-on-v6 port 53 { any; };"  >> /etc/named.conf
    echo "        directory       \"/var/named\";"  >> /etc/named.conf
    echo "        dump-file       \"/var/named/data/cache_dump.db\";"  >> /etc/named.conf
    echo "        statistics-file \"/var/named/data/named_stats.txt\";"  >> /etc/named.conf
    echo "        memstatistics-file \"/var/named/data/named_mem_stats.txt\";"  >> /etc/named.conf
    echo "        allow-query     { any; };"  >> /etc/named.conf
    echo "        allow-recursion {"none";};"  >> /etc/named.conf
    echo "        recursion no;"  >> /etc/named.conf
    echo "};"  >> /etc/named.conf
    echo "logging {"  >> /etc/named.conf
    echo "      channel default_debug {" >> /etc/named.conf
    echo "              file \"data/named.run\";"  >> /etc/named.conf
    echo "              severity dynamic; " >> /etc/named.conf
    echo "        };" >> /etc/named.conf
    echo "};" >> /etc/named.conf
    echo "zone "." IN {" >> /etc/named.conf
    echo "        type hint;" >> /etc/named.conf
    echo "        file \"named.ca\";" >> /etc/named.conf
    echo "};" >> /etc/named.conf
    echo "include \"/etc/named.conf.local\";" >> /etc/named.conf

    touch /etc/named.conf.local
    systemctl enable named #> /dev/null 2>&1
    systemctl start named #> /dev/null 2>&1
    systemctl enable haveged #> /dev/null 2>&1
    systemctl start haveged #> /dev/null 2>&1
    #echo -e "${green}done! ${NC}\n"

# Webalizer, and AWStats
    #echo -n "Installing Webalizer, and AWStats... "
    yum -y install webalizer awstats perl-DateTime-Format-HTTP perl-DateTime-Format-Builder #> /dev/null 2>&1
    sed -i "s/Require local/Require all granted/" /etc/httpd/conf.d/awstats.conf
    systemctl restart httpd #> /dev/null 2>&1
    #echo -e "${green}done! ${NC}\n"

# Jailkit
    #echo -n "Installing Jailkit... "
    cd /usr/local/src
    wget http://olivier.sessink.nl/jailkit/jailkit-2.19.tar.gz #> /dev/null 2>&1
    tar xvfz jailkit-2.19.tar.gz
    cd jailkit-2.19
    ./configure #> /dev/null 2>&1
    make -j `cat /proc/cpuinfo | grep cores | wc -l` #> /dev/null 2>&1
    make install #> /dev/null 2>&1
    #echo -e "${green}done! ${NC}\n"
    
# Fail2Ban
    #echo -n "Installing Fail2Ban... "
    yum -y install iptables-services fail2ban fail2ban-systemd #> /dev/null 2>&1
    systemctl stop firewalld #> /dev/null 2>&1
    systemctl mask firewalld #> /dev/null 2>&1
    systemctl disable firewalld #> /dev/null 2>&1
    systemctl stop firewalld #> /dev/null 2>&1
    echo "[sshd]" >> /etc/fail2ban/jail.local
    echo "enabled = true" >> /etc/fail2ban/jail.local
    echo "action = iptables[name=sshd, port=ssh, protocol=tcp]" >> /etc/fail2ban/jail.local
    echo "" >> /etc/fail2ban/jail.local
    echo "[pure-ftpd]" >> /etc/fail2ban/jail.local
    echo "enabled = true" >> /etc/fail2ban/jail.local
    echo "action = iptables[name=FTP, port=ftp, protocol=tcp]" >> /etc/fail2ban/jail.local
    echo "maxretry = 3" >> /etc/fail2ban/jail.local
    echo "" >> /etc/fail2ban/jail.local
    echo "[dovecot]" >> /etc/fail2ban/jail.local
    echo "enabled = true" >> /etc/fail2ban/jail.local
    echo "action = iptables-multiport[name=dovecot, port="pop3,pop3s,imap,imaps", protocol=tcp]" >> /etc/fail2ban/jail.local
    echo "maxretry = 5" >> /etc/fail2ban/jail.local
    echo "" >> /etc/fail2ban/jail.local
    echo "[postfix-sasl]" >> /etc/fail2ban/jail.local
    echo "enabled = true" >> /etc/fail2ban/jail.local
    echo "action = iptables-multiport[name=postfix-sasl, port="smtp,smtps,submission", protocol=tcp]" >> /etc/fail2ban/jail.local
    echo "maxretry = 3" >> /etc/fail2ban/jail.local

    mkdir /var/run/fail2ban
    systemctl enable fail2ban #> /dev/null 2>&1
    systemctl start fail2ban #> /dev/null 2>&1
    #echo -e "${green}done! ${NC}\n"

# Mailman
    #echo -n "Installing Mailman... "
    yum -y install mailman #> /dev/null 2>&1
    touch /var/lib/mailman/data/aliases
    postmap /var/lib/mailman/data/aliases
    sed -i "s/DEFAULT_URL_HOST   = fqdn/DEFAULT_URL_HOST   = $CFG_HOSTNAME_FQDN/" /etc/mailman/mm_cfg.py
    sed -i "s/DEFAULT_EMAIL_HOST = fqdn/DEFAULT_URL_HOST   = $CFG_HOSTNAME_FQDN/" /etc/mailman/mm_cfg.py
    /usr/lib/mailman/bin/newlist -q mailman ${MMLISTOWNER} ${MMLISTPASS} | grep '/usr/lib' >> /etc/aliases
    ln -s /usr/lib/mailman/mail/mailman /usr/bin/mailman
    newaliases
    systemctl restart postfix #> /dev/null 2>&1
    sed -i "s,\(\ScriptAlias.*\),\1\nScriptAlias /cgi-bin/mailman/ /usr/lib/mailman/cgi-bin/,g" /etc/httpd/conf.d/mailman.conf
    sed -i "s/Alias \/pipermail\/ \/var\/lib\/mailman\/archives\/public\//Alias \/pipermail \/var\/lib\/mailman\/archives\/public\//" /etc/httpd/conf.d/mailman.conf
    systemctl restart httpd #> /dev/null 2>&1
    systemctl enable mailman #> /dev/null 2>&1
    systemctl start mailman #> /dev/null 2>&1
    #echo -e "${green}done! ${NC}\n"

# Roundcube
    #echo -n "Installing Roundcube... "
    yum -y install roundcubemail #> /dev/null 2>&1
    mysql -u root -p$CFG_MYSQL_ROOT_PWD -e 'CREATE DATABASE '$ROUNDCUBE_DB';'
	mysql -u root -p$CFG_MYSQL_ROOT_PWD -e "CREATE USER '$ROUNDCUBE_USER'@localhost IDENTIFIED BY '$ROUNDCUBE_PWD'"
	mysql -u root -p$CFG_MYSQL_ROOT_PWD -e 'GRANT ALL PRIVILEGES on '$ROUNDCUBE_DB'.* to '$ROUNDCUBE_USER'@localhost'
	mysql -u root -p$CFG_MYSQL_ROOT_PWD -e 'FLUSH PRIVILEGES;'
    cat /etc/roundcubemail/config.inc.php.sample | grep -v db_dsnw > /etc/roundcubemail/config.inc.php
	sed -i "/$config = array();/ a \$config[\\'db_dsnw\\'] = \\'mysql:\/\/$ROUNDCUBE_USER:$ROUNDCUBE_PWD@localhost\/$ROUNDCUBE_DB\\';" /etc/roundcubemail/config.inc.php
	mysql -u $ROUNDCUBE_USER -p$ROUNDCUBE_PWD $ROUNDCUBE_DB < /usr/share/roundcubemail/SQL/mysql.initial.sql 
    mv /etc/httpd/conf.d/roundcubemail.conf /etc/httpd/conf.d/roundcubemail.conf_bak
    echo "Alias /roundcubemail /usr/share/roundcubemail" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "Alias /webmail /usr/share/roundcubemail" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "<Directory /usr/share/roundcubemail/>" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "        Options none" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "        AllowOverride Limit" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "        Require all granted" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "</Directory>" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "<Directory /usr/share/roundcubemail/installer>" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "        <IfModule mod_authz_core.c>" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "          Require local" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "        </IfModule>" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "</Directory>" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "<Directory /usr/share/roundcubemail/bin/>" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "    Order Allow,Deny" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "    Deny from all" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "</Directory>" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "<Directory /usr/share/roundcubemail/plugins/enigma/home/>" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "    Order Allow,Deny" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "    Deny from all" >> /etc/httpd/conf.d/roundcubemail.conf
    echo "</Directory>" >> /etc/httpd/conf.d/roundcubemail.conf
    systemctl restart httpd #> /dev/null 2>&1
    #echo -e "${green}done! ${NC}\n"

# ISPConfig


}