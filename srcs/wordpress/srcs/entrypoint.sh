#!/bin/sh

/telegraf/usr/bin/telegraf &

nginx -t || exit 1

openrc
touch /run/openrc/softlevel

rc-update add php-fpm7 default
rc-service php-fpm7 restart

nginx -g 'daemon off;'
