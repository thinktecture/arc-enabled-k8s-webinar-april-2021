#!/bin/bash

echo "Enable AZ extensions"
#az extension add --name connectedk8s
#az extension add --name k8sconfiguration
echo "Update AZ extensions"
az extension update --name connectedk8s
az extension update --name k8sconfiguration

echo "Register required providers (up to 10mins)"
# az provider register --namespace Microsoft.Kubernetes
# az provider register --namespace Microsoft.KubernetesConfiguration
# az provider register --namespace Microsoft.ExtendedLocation
az provider show -n Microsoft.Kubernetes -o table
az provider show -n Microsoft.KubernetesConfiguration -o table
az provider show -n Microsoft.ExtendedLocation -o table

echo ""
echo "hit RETURN to continue"
read ShouldContinue


echo "Verify Service Principal Permissions:"
az role assignment list --assignee $ARC_CLIENT_ID --all -o table --query "[].roleDefinitionName"
echo ""
echo "Hit return if SP has role Kubernetes Cluster - Azure Arc Onboarding"
read ShouldContinue

kubectl config get-contexts

echo "Please provide the name of the desired kubernetes context:"
read KUBE_CTX
kubectl config use-context $KUBE_CTX

echo "Provide a name for the Azure Arc resouce (consider looking at the other onboarded clusters first)"
read ARC_NAME

echo "Targeting Tenant " $ARC_TENANT_ID
echo "Will login with Service Princial now (HIT RETURN to continue)"
read ShouldContinue
az login --service-principal -u $ARC_CLIENT_ID -p $ARC_CLIENT_SECRET --tenant $ARC_TENANT_ID --allow-no-subscriptions
az account set --subscription $ARC_SUBSCRIPTION_ID

echo "Provide a Resource Group name:"
read RG_NAME
az connectedk8s connect -g $RG_NAME -n $ARC_NAME --tags location=Germany vendor=DigitalOcean

az connectedk8s list -g $RG_NAME -o table
