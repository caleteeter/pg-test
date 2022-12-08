#!/bin/bash

managedIdentity=$1
resourceGroupName=$2
serverName=$3
administratorLogin=$4
administratorLoginPassword=$5
aksClusterName=$6

# login
az login --identity --username $managedIdentity

# get credentials for kubectl used for data plane operations
az aks install-cli
az aks get-credentials --name $aksClusterName --resource-group $resourceGroupName

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
psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "CREATE DATABASE ctest;"

psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "create user domain1 with password '$administratorLoginPassword'"
psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "create user domain2 with password '$administratorLoginPassword'"
psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "create user participant1 with password '$administratorLoginPassword'"
psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "create user participant2 with password '$administratorLoginPassword'"
psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "create user participant3 with password '$administratorLoginPassword'"

psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "grant all privileges on database domain1 to domain1"
psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "grant all privileges on database domain2 to domain2"
psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "grant all privileges on database participant1 to participant1"
psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "grant all privileges on database participant2 to participant2"
psql "host=$serverName.postgres.database.azure.com port=5432 dbname=postgres user=$administratorLogin sslmode=require" -c "grant all privileges on database participant3 to participant3"

# create resources in k8s
kubectl create namespace canton
kubectl -n canton create secret docker-registry digitalasset-microsoft-docker.jfrog.io --docker-server='digitalasset-microsoft-docker.jfrog.io' --docker-username='cale.teeter@microsoft.com' --docker-password='' --docker-email='cale.teeter@microsoft.com'
# kubectl -n canton create secret generic canton-postgresql-bootstrap --from-file="${current_dir}/postgresql.sql"
kubectl -n canton create secret generic canton-postgresql --from-literal=domain='umn2uAR3byW4uDERUWD4s19RebC6eb2_pr6eCmfa' --from-literal=json='dvpKN3tNBV9SBZ19qNFJqWPtHzKiZXp9Vn?#i1eU' --from-literal=mediator='eFDW5kY5y2sThMnrD14BVajGdrJQK1zpjXBs49_m' --from-literal=participant1='EQY#QPmnUbx_eXp1HzJmK98fKcUVryLCa31xq6NR' --from-literal=participant2='iAZfuP27a2GRci1jWdzXPWcDJ4Y1KtHY59XvapiJ' --from-literal=sequencer='mfd?f=mVDrtKwL=UjDGJXAEbkWm22Zgu5QBEz=UJ' --from-literal=trigger='h68M#M1uL4pGgwU1dXN9zN7j+KBhQprNBbA9NJHP'
# kubectl -n canton create configmap canton-postgresql --from-file=extended.conf="${current_dir}/postgresql.conf"