#!/bin/sh

RED='\033[1;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
END='\033[0;0m'

build_images()
{
  echo "${GREEN}Building images${END}"

  echo "${PURPLE}Building Wordpress${END}"
   docker build -t img_wp          ./srcs/wordpress
  echo "${PURPLE}Building Grafana${END}"
  docker build -t img_grafana     ./srcs/grafana
  echo "${PURPLE}Building InfluxDB${END}"
  docker build -t img_influx      ./srcs/influxdb
   echo "${PURPLE}Building Nginx${END}"
   docker build -t img_nginx       ./srcs/nginx
   echo "${PURPLE}Building Ftps${END}"
   docker build -t img_ftps        ./srcs/ftps
   echo "${PURPLE}Building Phpmyadmin${END}"
   docker build -t img_php         ./srcs/phpmyadmin
   echo "${PURPLE}Building Mysql${END}"
   docker build -t img_mysql       ./srcs/mysql
}

install_metallb()
{

  kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e "s/strictARP: false/strictARP: true/" | kubectl diff -f - -n kube-system
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
  kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
  kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
  kubectl apply -f ./srcs/deployment/metallb-config.yaml
}
apply_yaml()
{
    echo "${BLUE}Deploying YAML${END}"
    kubectl apply -f ./srcs/deployment/volumes.yaml
    kubectl apply -f ./srcs/deployment/grafana.yaml
    kubectl apply -f ./srcs/deployment/influxdb.yaml
     kubectl apply -f ./srcs/deployment/nginx.yaml
     kubectl apply -f ./srcs/deployment/ftps.yaml
     kubectl apply -f ./srcs/deployment/php.yaml
     kubectl apply -f ./srcs/deployment/mysql.yaml
     kubectl apply -f ./srcs/deployment/wordpress.yaml
}
get_dashboard_access()
{
  kubectl apply -f ./srcs/deployment/admin_creation.yaml
  kubectl apply -f ./srcs/deployment/dashboard-admin.yaml
  echo "${BLUE}Dashboard Token${END}"
  kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
}

  sudo chmod 777 /var/run/docker.sock
  minikube delete
  echo "${BLUE}STARTING the Minikube cluster${END}"
	minikube start --cpus=2 --memory 4096 --vm-driver=docker
 	minikube addons enable metrics-server
  minikube addons enable default-storageclass
  minikube addons enable storage-provisioner
	minikube addons enable dashboard
  eval $(minikube -p minikube docker-env)

  install_metallb
  build_images
  apply_yaml
  sleep 10
  minikube dashboard
