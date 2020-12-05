#!/bin/sh

if pgrep "nginx" > /dev/null
then
  exit 0
else
  exit 1
fi
