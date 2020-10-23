#!/usr/bin/env bash

yum install -y httpd
systemctl start httpd
systemctl enable httpd

echo '<h1>Default Page: Project = ${project_name} Environment = ${environment}</h1>' >> /var/www/html/index.html

ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
HOST=`curl -s http://169.254.169.254/latest/meta-data/hostname`

echo "</br>instance-id: $ID<br/>" >> /var/www/html/index.html
echo "</br>hostname: $HOST<br/>" >> /var/www/html/index.html
