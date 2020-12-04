#!/bin/sh

RED='\033[1;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
END='\033[0;0m'

if [ $# -eq 0 ]
then
  echo "${RED}PLEASE PROVIDE AN ENGINE : ${END}"
  echo "minikube kind docker"
  exit
fi
if [ $1 = "minikube" ]
then
  echo "${BLUE}STARTING the Minikube cluster${END}"
elif [ $1 = "kind" ]
then
  echo "${YELLOW}STARTING the Kind cluster${END}"
elif [ $1 = "docker" ]
then
  echo "${PURPLE}STARTING the Docker network${END}"
  sh setup_docker.sh
fi
