#!/bin/bash

echo "Targeting Tenant " $ARC_TENANT_ID

echo "Verify Service Principal Permissions:"
az role assignment list --assignee $ARC_CLIENT_ID --all -o table --query "[].roleDefinitionName"
echo ""

echo "Hit return if SP has role Log Analytics Contributor"
read ShouldContinue


echo "Please provide the name of your Arc enabled Kubernetes cluster:"
read arcClusterName

echo "Please provide the name of the Resource Group (Hit RETURN to continue):"
read rgName

echo "Please provide the resource ID of your Log Analytics Workspace:"
read lawResourceId

kubectl config get-contexts

echo "Please provide the name of the desired kubernetes context: "
read KUBE_CTX
kubectl config use-context $KUBE_CTX

echo "Will login with Service Princial now (HIT RETURN to continue)"
read ShouldContinue
az login --service-principal -u $ARC_CLIENT_ID -p $ARC_CLIENT_SECRET --tenant $ARC_TENANT_ID --allow-no-subscriptions
az account set --subscription $ARC_SUBSCRIPTION_ID
echo ""

az k8s-extension create --name azuremonitor-containers --cluster-name $arcClusterName --resource-group $rgName --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings logAnalyticsWorkspaceResourceID=$lawResourceId
