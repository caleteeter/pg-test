#!/bin/bash

managedIdentity=$1
resourceGroupName=$2
serverName=$3
administratorLogin=$4
administratorLoginPassword=$5

# login
az login --identity --username $managedIdentity

# ensure the preview bits can be used with prompt in UI
az config set extension.use_dynamic_install=yes_without_prompt
az extension add -s https://azurecliprod.blob.core.windows.net/cli-extensions/rdbms_connect-0.1.0-py2.py3-none-any.whl -y

# create databases
az postgres flexible-server db create --charset 'UTF8' --collation "en_US.UTF8" --database-name 'domain1' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --charset 'UTF8' --collation "en_US.UTF8" --database-name 'domain2' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --charset 'UTF8' --collation "en_US.UTF8" --database-name 'participant1' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --charset 'UTF8' --collation "en_US.UTF8" --database-name 'participant2' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --charset 'UTF8' --collation "en_US.UTF8" --database-name 'participant3' --resource-group $resourceGroupName --server-name $serverName

# create users
az postgres flexible-server execute --admin-user $administratorLogin --admin-password $administratorLoginPassword --name $serverName --database-name 'domain1' --querytext "create user domain1 with password 'P@ssw0rd123!'"