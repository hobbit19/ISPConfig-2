# ISPConfig Automation Script

Tested on :
- CentOS 7 ([KSCloud](http://www.kscloud.kr/))

Before start be sure to configure your server following the following guides:
- Centos 7: http://www.howtoforge.com/centos-7-server

You can Choose during install:
- Apache
- Dovecot
- Quota
- Jailkit
- Roundcube
- ISPConfig 3 Standard

This Script following:
https://www.howtoforge.com/tutorial/perfect-server-centos-7-3-apache-mysql-php-pureftpd-postfix-dovecot-and-ispconfig

* CentOS 7 Install
```shell
cd /usr/local/src; wget --no-check-certificate -O installer.tgz "https://github.com/ysyukr/ISPConfig/master"; tar zxvf installer.tgz; cd *ispconfig*; bash install.sh
```
