#!/bin/bash

sudo su

yum -y install httpd

systemctl start httpd
systemctl enable httpd
systemctl status httpd

echo "Hostname $(hostname)" > /var/www/index.html