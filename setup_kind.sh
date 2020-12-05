#!/bin/sh

GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[1;35'
END='\033[0;0m'

echo "${GREEN}Installing Kind${END}"
GO111MODULE="on" go get sigs.k8s.io/kind@v0.9.0
mv /home/$USER/go .
mv go/kind .
sudo rm -rf go

./kind delete cluster
./kind create cluster

#minikube delete
##docker network rm ft_network
#
#minikube start --driver=virtualbox
#eval $(minikube docker-env)
#
#minikube addons enable metrics-server
#minikube addons enable metallb


# actually apply the changes, returns nonzero returncode on errors only
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system

#>>>>>Deploiement du Dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
#>>>>>Création d'un user pour le dashboard
kubectl apply -f ./srcs/dashboard-admin.yaml
#>>>>>cette commande sert à obtenir un jeton de connexion pour le dashboard
#kubectl get secret -n kubernetes-dashboard $(kubectl get serviceaccount admin-user -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode

#>>>>>Installation de MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)" # On first install only

#>>>>>ConfigMap
kubectl create -f ./srcs/metallb/metallb.yaml

#>>>>> 172.18.1.2
docker build -t img_nginx ./srcs/nginx > /dev/null 2>&1
./kind load docker-image img_nginx
kubectl apply -f ./srcs/nginx/nginx.yaml

##>>>>> 172.18.1.3
#docker build -t img_ftps ./srcs/ftps > /dev/null 2>&1
##./kind load docker-image img_ftps
#kubectl apply -f ./srcs/ftps/ftps.yaml
##
##>>>>> 172.18.1.4
#docker build -t img_php ./srcs/phpmyadmin > /dev/null 2>&1
##./kind load docker-image img_php
#kubectl apply -f ./srcs/phpmyadmin/php.yaml
##
###>>>> ClusterIP
#docker build -t img_mysql ./srcs/mysql > /dev/null 2>&1
##./kind load docker-image img_mysql
#kubectl apply -f ./srcs/mysql/mysql.yaml

#>>>>>cette commande pour avoir des infos sur l'ip des services
#kubectl get svc nginx

#>>>>>pour activer le dashboard
#kubectl proxy
#>>>>>http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

# minikube dashboard &

#>>>>> check restart count
#kubectl describe pod PODNAME | grep Restart