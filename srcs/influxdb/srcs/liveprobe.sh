#!/bin/sh

if pgrep "influxd" > /dev/null
then
  exit 0
else
  exit 1
fi
