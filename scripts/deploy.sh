#!/bin/bash

managedIdentity=$1
resourceGroupName=$2
serverName=$3
dbName=$4

# login
az login --identity --username $managedIdentity --allow-no-subscriptions

az postgres db create --name $dbName --resource-group $resourceGroupName --server-name $serverName
