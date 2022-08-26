#!/bin/bash

managedIdentity=$1
resourceGroupName=$2
serverName=$3
administratorLogin=$4
administratorLoginPassword=$5

# login
az login --identity --username $managedIdentity

# create databases
az postgres flexible-server db create --database-name 'domain1' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --database-name 'domain2' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --database-name 'participant1' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --database-name 'participant2' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --database-name 'participant3' --resource-group $resourceGroupName --server-name $serverName

# create users
az postgres flexible-server execute --admin-user $administratorLogin --admin-password $administratorLoginPassword --name $serverName --database-name 'domain1' --querytext 'create user domain1 with password "P@ssw0rd123!"'