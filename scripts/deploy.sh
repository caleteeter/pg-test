#!/bin/bash

managedIdentity=$1
resourceGroupName=$2
serverName=$3

# login
az login --identity --username $managedIdentity

# create databases
az postgres db create --name 'domain1' --resource-group $resourceGroupName --server-name $serverName
az postgres db create --name 'domain2' --resource-group $resourceGroupName --server-name $serverName
az postgres db create --name 'participant1' --resource-group $resourceGroupName --server-name $serverName
az postgres db create --name 'participant2' --resource-group $resourceGroupName --server-name $serverName
az postgres db create --name 'participant3' --resource-group $resourceGroupName --server-name $serverName