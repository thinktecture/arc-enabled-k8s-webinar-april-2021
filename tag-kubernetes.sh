#!/bin/bash
echo "Targeting Tenant " $ARC_TENANT_ID

echo "Will login with Service Princial now (HIT RETURN to continue)"
read ShouldContinue
az login --service-principal -u $ARC_CLIENT_ID -p $ARC_CLIENT_SECRET --tenant $ARC_TENANT_ID --allow-no-subscriptions
az account set --subscription $ARC_SUBSCRIPTION_ID

echo "Please provide the resource ID of your Arc enabled Kubernetes cluster:"
read ARC_RESOURCE_ID

echo "Please provide the name of the tag:"
read TAG_NAME

echo "Please provide the value of the tag:"
read TAG_VALUE

az tag update --operation merge --resource-id $ARC_RESOURCE_ID --tags $TAG_NAME=$TAG_VALUE
