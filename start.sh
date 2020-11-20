#!/bin/bash

# stop everything running
docker container stop c_nginx c_wp c_php c_mysql c_ftp
docker container rm   c_nginx c_wp c_php c_mysql c_ftp
docker network rm ft_network
service nginx stop
service mysql stop

# create network
docker network create --subnet=172.18.0.0/16 ft_network

# create images
docker build -t img_php ./srcs/phpmyadmin/
docker run -itd --name c_php      -p 5000:5000        --net ft_network --ip 172.18.0.2  img_php

docker build -t img_wp ./srcs/wordpress
docker run -itd --name c_wp       -p 5050:5050        --net ft_network --ip 172.18.0.3  img_wp

docker build -t img_ftp ./srcs/ftps
docker run -itd --name c_ftp      -p 21:21            --net ft_network --ip 172.18.0.4  img_ftp

docker build -t img_mysql ./srcs/mysql
docker run -itd --name c_mysql    -p 3306:3306        --net ft_network --ip 172.18.0.5  img_mysql

docker build -t img_nginx ./srcs/nginx/
docker run -itd --name c_nginx    -p 80:80 -p 443:443 --net ft_network --ip 172.18.0.6  img_nginx