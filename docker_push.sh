#!/bin/bash
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add     
sudo apt-get install apt-transport-https -y
sudo apt-get update && sudo apt-get install -y azure-cli

az login --service-principal --username $AZ_APP_ID --pa ssword $AZ_PASSWORD --tenant $AZ_TENANT
sudo az aks install-cli
sudo az aks get-credentials --resource-group test --name test

sudo kubectl apply -f ./kubernetes/staging