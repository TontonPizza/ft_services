#!/bin/sh

if pgrep "vsftpd" > /dev/null
then
  exit 0
else
  exit 1
fi
