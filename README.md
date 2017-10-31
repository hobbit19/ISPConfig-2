# ISPConfig Automation Script

Tested on :
- CentOS 7 ([KSCloud](http://www.kscloud.kr/))
- Ubuntu 16.04 ([KSCloud](http://www.kscloud.kr/))

Before start be sure to configure your server following the following guides:
- Centos 7: https://www.howtoforge.com/tutorial/perfect-server-centos-7-3-apache-mysql-php-pureftpd-postfix-dovecot-and-ispconfig/
- Ubuntu 16.04 : https://www.howtoforge.com/tutorial/perfect-server-ubuntu-16.04-with-apache-php-myqsl-pureftpd-bind-postfix-doveot-and-ispconfig

This Script following:
https://www.howtoforge.com/tutorial/perfect-server-centos-7-3-apache-mysql-php-pureftpd-postfix-dovecot-and-ispconfig
https://www.howtoforge.com/tutorial/perfect-server-ubuntu-16.04-with-apache-php-myqsl-pureftpd-bind-postfix-doveot-and-ispconfig

* Script download and run
```shell
cd /usr/local/src; wget --no-check-certificate -O installer.tgz "https://github.com/ysyukr/ISPConfig/tarball/master"; tar zxvf installer.tgz; cd *ISPConfig*; bash install.sh
```