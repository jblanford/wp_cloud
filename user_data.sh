#!/usr/bin/env bash

yum install -y httpd
systemctl start httpd
systemctl enable httpd

echo '<h1>Default Page: Project = ${project_name} Environment = ${environment}</h1>' >> /var/www/html/index.html
