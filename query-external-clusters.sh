#!/bin/bash

echo "Provide a Resource Group name:"
read RG_NAME

az graph query -o table -q "resources | where resourceGroup =~ '$RG_NAME' and type =~ 'microsoft.kubernetes/connectedclusters' | extend vendor=tostring(tags.Vendor) | extend department=tostring(tags.Department) | project name, location, vendor, department | where vendor =~ 'DigitalOcean'"
