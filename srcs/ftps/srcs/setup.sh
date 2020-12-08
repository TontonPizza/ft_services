#!/bin/sh
adduser -D -h /var/ftp $toto
echo "$toto:$tata" | chpasswd
vsftpd /etc/vsftpd/vsftpd.conf
