#!/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
myname="kumud"
s3_bucket="upgrad-kumud/logs"

sudo apt update -y
sudo apt install apache2 -y

if [ `service apache2 status | grep running | wc -l` == 1 ]
then
	echo "Apache2 is running"
else
	echo "Apache2 is not running"
	echo "Starting apache2"
	sudo service apache2 start 

fi

if [ `service apache2 status | grep enabled | wc -l` == 1 ]
then
	echo "Apache2 is enabled"
else
	echo "Apache2 is not enabled"
	echo "Enabling apache2"
	sudo systemctl enable apache2
fi

echo "Compressing logs and storing into /tmp"

cd /var/log/apache2/

tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar *.log

echo "Copying logs to s3"

aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar

