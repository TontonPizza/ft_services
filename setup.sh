#!/bin/bash

# stop everything running
minikube delete
#docker network rm ft_network

minikube start --driver=virtualbox
eval $(minikube docker-env)

minikube addons enable metrics-server

# see what changes would be made, returns nonzero returncode if different
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system

# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" # On first install only

kubectl apply -f srcs/metallb/metallb.yaml # voir si on peut le mettre à la fin de l'autre liste




# create images
#docker build -t img_php ./srcs/phpmyadmin/
##docker run -itd --name c_php      -p 5000:5000        --net ft_network --ip 172.18.0.2  img_php
#docker build -t img_wp ./srcs/wordpress
##docker run -itd --name c_wp       -p 5050:5050        --net ft_network --ip 172.18.0.3  img_wp
docker build -t img_ftps ./srcs/ftps
##docker run -itd --name c_ftp      -p 21:21            --net ft_network --ip 172.18.0.4  img_ftp
#docker build -t img_mysql ./srcs/mysql
#docker run -itd --name c_mysql    -p 3306:3306        --net ft_network --ip 172.18.0.5  img_mysql
docker build -t img_nginx ./srcs/nginx/
#docker run -itd --name c_nginx    -p 80:80 -p 443:443 --net ft_network --ip 172.18.0.6  img_nginx
#docker build -t img_grafana ./srcs/grafana
#
#docker build -t img_influxdb ./srcs/influxdb

kubectl apply -f ./srcs/nginx/nginx.yaml
kubectl apply -f ./srcs/ftps/ftps.yaml

minikube dashboard &