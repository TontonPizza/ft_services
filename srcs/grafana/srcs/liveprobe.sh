#!/bin/sh

if pgrep "grafana" > /dev/null
then
  exit 0
else
  exit 1
fi
