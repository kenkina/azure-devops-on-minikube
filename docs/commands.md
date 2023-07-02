<br />
<div align="center">
  <h1 align="center">Jenkins on Minikube</h1>
</div>



## SH commands

```sh
# Terraform
terraform init
terraform plan
terraform apply

terraform destroy


# Installation
sh scripts/_init.sh

# Uninstallation
sh scripts/_wipe_.sh


# Start, stop or delete Minikube
minikube start --cpus=4 --memory=6000m
minikube dashboard --url

minikube stop
minikube delete --all


# Kill kubectl process like `kubectl port-forward`
killall kubectl


# Create Jenkins namespace
kubectl create ns devops-jenkins

# Execute commands in pod
kubectl exec -n devops-jenkins -it svc/jenkins -c jenkins -- /bin/sh


# String format with `date` and `BUILD_ID`
BUILD_ID=2
dateformat=$(date --utc +"%Y%m%d.%H%M.$BUILD_ID")
echo $dateformat


#kubectl proxy --port=8001 --disable-filter=true
kubectl proxy --port=8001 --accept-hosts="^*.ngrok-free.app$"

ngrok http 8001


tunnels=$(curl -s http://localhost:4040/api/tunnels)
public_url=$(echo "$tunnels" | grep -o '"public_url":"[^"]*' | sed 's/"public_url":"//')
sed 's|server: .*$|server: '"$public_url"'|g' /tmp/.kube/config


sed -i 's/server: .*/server: https:\/\/192.168.49.2:8443/g' /tmp/.kube/config

```
