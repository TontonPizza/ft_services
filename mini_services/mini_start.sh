#!/usr/bin/zsh

minikube start --cpus=2 --memory 3072 --vm-driver=docker
minikube addons enable metrics-server
minikube addons enable default-storageclass
minikube addons enable storage-provisioner
minikube addons enable dashboard

eval $(minikube -p minikube docker-env)

kubectl get configmap kube-proxy -n kube-system -o yaml | sed -e "s/strictARP: false/strictARP: true/" | kubectl diff -f - -n kube-system
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f srcs/deployment/metallb-config.yaml

docker build -t nginx-image ./srcs/nginx
kubectl apply -f srcs/deployment/nginx.yaml

kubectl get all
minikube dashboard