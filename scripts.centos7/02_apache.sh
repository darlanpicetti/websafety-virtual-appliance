#!/bin/bash

# all web packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install python libs and compiler (needed for reportlab)
yum -y install \
	python-devel python-pip python-ldap pyOpenSSL \
	net-tools libjpeg-devel zlib-devel gcc-c++

# install python django for web ui
pip install django==1.11.7
pip install reportlab==3.4.0
pip install pytz

# install apache web server to run web ui
yum -y install httpd mod_wsgi krb5-workstation mc

# make apache autostart on reboot
systemctl enable httpd.service

# this fixes some apache errors when working with python-django wsgi
echo "WSGISocketPrefix /var/run/wsgi" >> /etc/httpd/conf.d/wsgi.conf

# and restart apache
service httpd restart
