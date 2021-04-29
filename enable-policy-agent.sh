#!/bin/bash

echo "Targeting Tenant " $ARC_TENANT_ID

echo "Verify Service Principal Permissions:"
az role assignment list --assignee $ARC_CLIENT_ID --all -o table --query "[].roleDefinitionName"
echo ""

echo "Hit return if SP has role Policy Insights Data Writer (Preview)"
read ShouldContinue

echo "Please provide the ResourceID of your Arc enabled Kubernetes cluster:"
read ARC_RESOURCE_ID

kubectl config get-contexts

echo "Please provide the name of the desired kubernetes context: "
read KUBE_CTX
kubectl config use-context $KUBE_CTX

echo "Will login with Service Princial now (HIT RETURN to continue)"
read ShouldContinue
az login --service-principal -u $ARC_CLIENT_ID -p $ARC_CLIENT_SECRET --tenant $ARC_TENANT_ID --allow-no-subscriptions
az account set --subscription $ARC_SUBSCRIPTION_ID
echo ""

helm repo add azure-policy https://raw.githubusercontent.com/Azure/azure-policy/master/extensions/policy-addon-kubernetes/helm-charts
helm repo update

helm install azure-policy-addon azure-policy/azure-policy-addon-arc-clusters --set azurepolicy.env.resourceid=$ARC_RESOURCE_ID --set azurepolicy.env.clientid=$ARC_CLIENT_ID --set azurepolicy.env.clientsecret=$ARC_CLIENT_SECRET --set azurepolicy.env.tenantid=$ARC_TENANT_ID
