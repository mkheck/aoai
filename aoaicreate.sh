#!/bin/bash
# Author  : Mark A. Heckler
# Notes   : 1. Set environment variables as appropriate below, then
#         : 2. Run with 'source aoaicreate.sh' from your shell/commandline to retain essential env vars
# History : 20240429 Official "version 1"

# Variables
export AOAI_RESOURCE_GROUP="new_resource_group_name"
export AOAI_LOCATION="eastus"
export AOAI_ACCOUNT_NAME="new_cognitive_services_name"
export AOAI_SKU="S0"
# Example of model name: "gpt-35-turbo". Run model list command in aoaiutilities.sh to see available models.
export AOAI_MODEL_NAME="chosen_model_name"
# Example of model version: "0613". The model list command shows available models/versions.
export AOAI_MODEL_VERSION="chosen_model_version"
# Example of deployment name: "gpt-35-turbo-0613"
export AOAI_DEPLOYMENT_NAME=$AOAI_MODEL_NAME-$AOAI_MODEL_VERSION

# Create a resource group
az group create -n $AOAI_RESOURCE_GROUP -l $AOAI_LOCATION

# Purge in case the account existed and was soft-deleted previously
az cognitiveservices account purge -l $AOAI_LOCATION \
  -n $AOAI_ACCOUNT_NAME \
  -g $AOAI_RESOURCE_GROUP

# Create an OpenAI account
az cognitiveservices account create \
  --kind "OpenAI" \
  -l $AOAI_LOCATION \
  -n $AOAI_ACCOUNT_NAME \
  -g $AOAI_RESOURCE_GROUP \
  --sku $AOAI_SKU \
  --yes

az cognitiveservices account deployment create --model-format "OpenAI" \
  --model-name $AOAI_MODEL_NAME \
  --model-version $AOAI_MODEL_VERSION \
  -n $AOAI_ACCOUNT_NAME \
  -g $AOAI_RESOURCE_GROUP \
  --deployment-name $AOAI_DEPLOYMENT_NAME

export AOAI_ENDPOINT=$(az cognitiveservices account show  -n $AOAI_ACCOUNT_NAME -g $AOAI_RESOURCE_GROUP --query "properties.endpoint" -o tsv)

export AOAI_API_KEY=$(az cognitiveservices account keys list -n $AOAI_ACCOUNT_NAME -g $AOAI_RESOURCE_GROUP --query "key1" -o tsv)
