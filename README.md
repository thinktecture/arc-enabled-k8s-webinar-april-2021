# Webinar: Azure Arc enabled Kubernetes - April 2021

This repository contains all the samples used as part of the "Azure Arc enabled Kubernetes" webinar, presented during April 2021.

## External Infrastructure

For demonstration purposes, external Kubernetes clusters (hosted on Digital Ocean) were integrated into Azure using Azure Arc enabled Kubernetes. The corresponding [Terraform](https://terraform.io) code is located in [infrastructure](infrastructure).

## Sample Scripts

The entire webinar assumes that an resource group with an log analytics workspace exists:

```bash
az group create --name <<RG_NAME>> --location westeurope
az monitor log-analytics workspace create -g <<RG_NAME>> -n <<WORKSPACE_NAME>>
```

The main folder contains several sample scripts. Those assume that you have created a new Service Principal and associated required roles as shown below:

```bash
az ad sp create-for-rbac -n azure-arc-enabled-kubernetes --skip-assignment -o jsonc

az role assignment create --assignee <<SP_ID>> \
  --role 'Policy Insights Data Writer (Preview)' \
  --scope /subscriptions/<<SUB_ID>>/resourcegroups/<<RG_NAME>>

az role assignment create --assignee <<SP_ID>> \
    --role 'Log Analytics Contributor' \
    --scope /subscriptions/<<SUB_ID>>/resourcegroups/<<RG_NAME>>/providers/microsoft.operationalinsights/workspaces/<<LAW_WORKSPACE_ID>>

# Assign Kubernetes Cluster - Azure Arc Onboarding Role by its identifier
az role assignment create --assignee <<SP_ID>> \
    --role 34e09817-6cbe-4d01-b1a2-e0eac5743d41 \
    --scope /subscriptions/<<SUB_ID>>/resourcegroups/<<RG_NAME>>
```

## The following scripts can be used:

- `onboard-kubernetes.sh` -> onboard a new external cluster
- `enable-arc-monitoring.sh` -> enable Arc monitoring with Azure Monitor
- `enable-policy-agent.sh` -> deploy Azure Policies stack to the external cluster
- `tag-kubernetes.sh` -> assign regular Azure Tags to external Kubernetes clusters
- `query-external-clusters.sh` -> query external clusters using Azure Resource Graph
