#!/bin/bash

# stop everything running
docker container stop c_nginx c_wp c_php c_mysql c_ftp
docker container rm   c_nginx c_wp c_php c_mysql c_ftp
docker network rm ft_network
service nginx stop
service mysql stop