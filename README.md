# ISPConfig 3 Automation Instll Script
# (ISPConfig 3 자동설치 스크립트)

Tested on(테스트 확인)
- CentOS 7 ([KSCloud](http://www.kscloud.kr/))
- Ubuntu 16.04 ([KSCloud](http://www.kscloud.kr/))

This Script following(스크립트 기준)
- https://www.howtoforge.com/tutorial/perfect-server-centos-7-3-apache-mysql-php-pureftpd-postfix-dovecot-and-ispconfig
- https://www.howtoforge.com/tutorial/perfect-server-ubuntu-16.04-with-apache-php-myqsl-pureftpd-bind-postfix-doveot-and-ispconfig

* Script download and run(스크립트 다운 및 실행)
```shell
cd /usr/local/src; wget --no-check-certificate -O installer.tgz "https://github.com/ysyukr/ISPConfig/tarball/master"; tar zxvf installer.tgz; cd *ISPConfig*; bash install.sh
```