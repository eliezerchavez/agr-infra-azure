#!/bin/bash

echo -n "Getting shared Subscription...                   "
if SUBSCRIPTION="$(az account list --all --query "[?contains(name, 'IB-USA-CORPO-M-COMMONSERVICES')].id" -o tsv; true)"; then
  echo -e "[\e[32mDONE\e[39m]"
else
  echo -e "[\e[31FAILED\e[39m]"
  exit -1
fi
echo -n "Getting utilities Resource Group....             "
if RESOURCE_GROUP="$(az group list --subscription=$SUBSCRIPTION --query "[?contains(name, 'rg-util-shared-001')].name" -o tsv; true)"; then
  echo -e "[\e[32mDONE\e[39m]"
else
  echo -e "[\e[31FAILED\e[39m]"
  exit -1
fi
echo -n "Getting tfstate Account Storage....              "
if ACCOUNT_NAME="$(az storage account list --subscription $SUBSCRIPTION -g $RESOURCE_GROUP --query "[[].name]" -o tsv; true)"; then
  echo -e "[\e[32mDONE\e[39m]"
else
  echo -e "[\e[31FAILED\e[39m]"
  exit -1
fi
echo -n "Getting tfstate Account Storage credentials....  "
if ACCOUNT_KEY="$(az storage account keys list --subscription $SUBSCRIPTION --resource-group $RESOURCE_GROUP --account-name $ACCOUNT_NAME --query '[0].value' -o tsv; true)"; then
  echo -e "[\e[32mDONE\e[39m]"
else
  echo -e "[\e[31FAILED\e[39m]"
  exit -1
fi

export ARM_ACCESS_KEY=$ACCOUNT_KEY

echo -e "\nEnvironment has been set, Happy Terraforming!"
