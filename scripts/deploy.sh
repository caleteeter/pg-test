#!/bin/bash

managedIdentity=$1
serverName=$2
adminName=$3
adminPwd=$4

# login
az login --identity --username $managedIdentity

az postgres server execute --name $serverName --admin-user $adminName --admin-password $adminPwd --databaseName 'postgres' -query-text 'CREATE DATABASE inventory;'

