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

# install the psql client
apk --no-cache add postgresql-client
export PGPASSWORD=$administratorLoginPassword

# create databases
az postgres flexible-server db create --charset 'UTF8' --collation "en_US.UTF8" --database-name 'domain1' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --charset 'UTF8' --collation "en_US.UTF8" --database-name 'domain2' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --charset 'UTF8' --collation "en_US.UTF8" --database-name 'participant1' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --charset 'UTF8' --collation "en_US.UTF8" --database-name 'participant2' --resource-group $resourceGroupName --server-name $serverName
az postgres flexible-server db create --charset 'UTF8' --collation "en_US.UTF8" --database-name 'participant3' --resource-group $resourceGroupName --server-name $serverName

# create users
psql "host=$serverName port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "CREATE DATABASE ctest;"

# az postgres flexible-server execute --debug --admin-user $administratorLogin --admin-password $administratorLoginPassword --name $serverName --database-name 'domain1' --querytext "create user domain1 with password 'P@ssw0rd123!'"