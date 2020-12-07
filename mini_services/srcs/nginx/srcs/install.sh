#!/bin/sh
apk update
apk add nginx openssl openrc openssh --no-cache #openrc activate automatically the service

apk add telegraf --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache

adduser --gecos GECOS adminssh
echo "adminssh:adminssh" | chpasswd #modify the password at the 1st connection

chown -R adminssh:adminssh /var/lib/nginx 
chown -R adminssh:adminssh /var/www
#change owner and allow index modification
chmod -R a+w /var/www
chmod -R a+w /etc/ssl

yes "" | openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/ssl/certs/localhost.crt -keyout /etc/ssl/certs/localhost.key -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=nagresel/CN=ft_services"

mkdir -p /run/nginx
openrc #allow system to switch at runlevel 
touch /run/openrc/softlevel #start the runlevel specified by the softlevel parameter if provided /etc/rc.conf
rc-update add telegraf
rc-update add sshd #Configure the service in order to be launched automatically at system starting
