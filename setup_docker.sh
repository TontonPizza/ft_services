#!/bin/sh

RED='\033[1;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
END='\033[0;0m'

echo "${GREEN} Stop everything running${END}"
docker container stop c_nginx c_wp c_php c_mysql c_ftps c_grafana c_influx
docker container rm c_nginx c_wp c_php c_mysql c_ftps c_grafana c_influx
docker network rm ft_network
#service nginx stop
#service mysql stop

echo "${GREEN}Creating network on ip 172.18.0.0/16${END}"
docker network create --subnet=172.20.0.1/16 ft_network

echo "${GREEN}Creating images and loading${END}"

docker build -t img_influx ./srcs/influxdb > /dev/null 2>&1
docker run -itd --name c_influx   -p 8086               --net ft_network --ip 172.20.0.8 img_influx

docker build -t img_php ./srcs/phpmyadmin > /dev/null 2>&1
docker run -itd --name c_php      -p 5000:5000          --net ft_network --ip 172.20.0.2 img_php

docker build -t img_wp ./srcs/wordpress > /dev/null 2>&1
docker run -itd --name c_wp       -p 5050:5050          --net ft_network --ip 172.20.0.3 img_wp

docker build -t img_ftps ./srcs/ftps > /dev/null 2>&1
docker run -itd --name c_ftps     -p 21:21              --net ft_network --ip 172.20.0.4 img_ftps

docker build -t img_mysql ./srcs/mysql > /dev/null 2>&1
docker run -itd --name c_mysql    -p 3306:3306          --net ft_network --ip 172.20.0.5 img_mysql

docker build -t img_nginx ./srcs/nginx > /dev/null 2>&1
docker run -itd --name c_nginx    -p 80:80 -p 443:443   --net ft_network --ip 172.20.0.6 img_nginx

docker build -t img_grafana ./srcs/grafana > /dev/null 2>&1
docker run -itd --name c_grafana  -p 3000:3000          --net ft_network --ip 172.20.0.7 img_grafana



echo "${GREEN}Done !${END}"