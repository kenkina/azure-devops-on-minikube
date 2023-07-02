#!/bin/sh

set -e

MINIKUBE_CONFIG_FILE="$HOME/.kube/config"

### main

echo "\n 0. Checking requeriments \n"
#. ./scripts/check-min-requirements.sh

echo "\n 1. Starting Minikube... \n"
minikube start --cpus=4 --memory=6000m
#minikube addons enable ingress

echo "\n 2. Installing Jenkins... \n"

echo "\n 2.2. Creating kubernetes secrets... \n"
. ./scripts/config-minikube-config.sh
