#!/bin/sh

RED='\033[1;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
END='\033[0;0m'


if [ $# -eq 0 ] ##################################################################
then
  echo "${RED}PLEASE PROVIDE AN ENGINE : ${END}"
  echo "minikube kind docker"
  exit
fi              ##################################################################

build_images()
{
  echo "${GREEN}Building images${END}"

  echo "${PURPLE}Building Wordpress${END}"
  docker build -t img_wp          ./srcs/wordpress > /dev/null 2>&1
  echo "${PURPLE}Building Grafana${END}"
  docker build -t img_grafana     ./srcs/grafana > /dev/null 2>&1
  echo "${PURPLE}Building InfluxDB${END}"
  docker build -t img_influx      ./srcs/influxdb > /dev/null 2>&1
  echo "${PURPLE}Building Nginx${END}"
  docker build -t img_nginx       ./srcs/nginx > /dev/null 2>&1
  echo "${PURPLE}Building Ftps${END}"
  docker build -t img_ftps        ./srcs/ftps > /dev/null 2>&1
  echo "${PURPLE}Building Phpmyadmin${END}"
  docker build -t img_php         ./srcs/phpmyadmin > /dev/null 2>&1
  echo "${PURPLE}Building Mysql${END}"
  docker build -t img_mysql       ./srcs/mysql > /dev/null 2>&1
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

    kubectl apply -f ./srcs/deployment/influxdb.yaml
    kubectl apply -f ./srcs/deployment/nginx.yaml
    kubectl apply -f ./srcs/deployment/ftps.yaml
    kubectl apply -f ./srcs/deployment/php.yaml
    kubectl apply -f ./srcs/deployment/mysql.yaml
    kubectl apply -f ./srcs/deployment/grafana.yaml
    kubectl apply -f ./srcs/deployment/wordpress.yaml
}

get_dashboard_access()
{
  kubectl apply -f ./srcs/deployment/admin_creation.yaml
  kubectl apply -f ./srcs/deployment/dashboard-admin.yaml
  echo "${BLUE}Dashboard Token${END}"
  kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
}

if [ $1 = "minikube" ] ##################################################################
then

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


elif [ $1 = "kind" ]   ##################################################################
then
 echo "${YELLOW}STARTING the Kind cluster${END}"
 sudo chmod 777 /var/run/docker.sock
 kind delete cluster
 echo "${GREEN}Installing Kind${END}"
 GO111MODULE="on" go get sigs.k8s.io/kind@v0.9.0
 sudo mv /home/$USER/go .
 sudo mv go/bin/kind .
 sudo rm -rf go

 ./kind delete cluster
 ./kind create cluster

 install_metallb
 kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
 build_images

 echo "${YELLOW}Loading images in kind${END}"
 ./kind load docker-image img_influx
 ./kind load docker-image img_nginx
 ./kind load docker-image img_ftps
 ./kind load docker-image img_php
 ./kind load docker-image img_mysql
 ./kind load docker-image img_grafana
 ./kind load docker-image img_wp

 apply_yaml

 get_dashboard_access

 echo "${YELLOW}Starting cluster at :${END}"
 echo "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login"
#  sudo kubectl get secret -n kubernetes-dashboard $(kubectl get serviceaccount admin-user -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode > credentials.txt
#  kubectl -n kube-system get secret | grep deployment-controller-token- | cut -c1-33 | kubectl -n kube-system describe secret | tail -1

 kubectl proxy



elif [ $1 = "docker" ] ##################################################################
then
  echo "${PURPLE}STARTING the Docker network${END}"
  echo "${GREEN} Stop everything running${END}"
  docker container stop c_nginx c_wp c_php c_mysql c_ftps c_grafana c_influx
  docker container rm c_nginx c_wp c_php c_mysql c_ftps c_grafana c_influx
  docker network rm ft_network
  #service nginx stop
  #service mysql stop

  echo "${GREEN}Creating network on ip 172.20.0.1/16${END}"
  docker network create --subnet=172.17.0.1/16 ft_network

  build_images

  echo "${GREEN}Running images in the network${END}"

  docker run -itd --name c_php      -p 5000:5000          --net ft_network --ip 172.20.0.2 img_php
  docker run -itd --name c_wp       -p 5050:5050          --net ft_network --ip 172.20.0.3 img_wp
  docker run -itd --name c_ftps     -p 21:21              --net ft_network --ip 172.20.0.4 img_ftps
  docker run -itd --name c_mysql    -p 3306:3306          --net ft_network --ip 172.20.0.5 img_mysql
  docker run -itd --name c_nginx    -p 80:80 -p 443:443   --net ft_network --ip 172.20.0.6 img_nginx
  docker run -itd --name c_grafana  -p 3000:3000          --net ft_network --ip 172.17.0.7 img_grafana
  docker run -itd --name c_influx   -p 8086:8086          --net ft_network --ip 172.17.0.8 img_influx

  echo "${GREEN}Done !${END}"
  exit 0
fi ##################################################################
