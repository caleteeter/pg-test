#!/bin/bash

dbName=$1
resourceGroupName=$2
serverName=$3

# login
az login --allow-no-subscriptions

az postgres db create --name $dbName --resource-group $resourceGroupName --server-name $serverName
