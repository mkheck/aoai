#!/bin/bash
# Author  : Mark A. Heckler
# Notes   : Run with 'source aoaicreate.sh' from your shell/commandline environment to retain essential env vars
# History : 20240429 Official "version 1"
#         : 20240830 Updates to models, Azure AI Search API key as required by releases+evolving APIs

# Variables
export AOAI_RESOURCE_GROUP="mh-openai-az-rg"
export AOAI_LOCATION="eastus"
export AOAI_ACCOUNT_NAME="mh-cogsvcs-acct"
export AOAI_SKU="S0"
export AOAI_MODEL_FORMAT="OpenAI"
export AOAI_MODEL_NAME="gpt-4o-mini"
# export AOAI_MODEL_NAME="gpt-4o"
# export AOAI_MODEL_VERSION="2024-05-13"
export AOAI_MODEL_VERSION="2024-07-18"
export AOAI_DEPLOYMENT_NAME=$AOAI_MODEL_NAME-$AOAI_MODEL_VERSION

export AOAI_IMAGE_MODEL_NAME="dall-e-3"
export AOAI_IMAGE_MODEL_VERSION="3.0"
export AOAI_IMAGE_DEPLOYMENT_NAME=$AOAI_IMAGE_MODEL_NAME-"3point0"

# export AOAI_EMBEDDING_MODEL_NAME="text-embedding-3-large"
# export AOAI_EMBEDDING_MODEL_VERSION="1"
export AOAI_EMBEDDING_MODEL_NAME="text-embedding-ada-002"
export AOAI_EMBEDDING_MODEL_VERSION="2"
export AOAI_EMBEDDING_DEPLOYMENT_NAME=$AOAI_EMBEDDING_MODEL_NAME-$AOAI_EMBEDDING_MODEL_VERSION

export AZ_AI_SEARCH_NAME="mh-ai-search"
export AZ_AI_SEARCH_SKU="standard"
# export AZ_AI_SEARCH_SKU="basic" NOTE: standard, standard2, standard3 valid options

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

az cognitiveservices account deployment create \
  --model-format $AOAI_MODEL_FORMAT \
  --model-name $AOAI_MODEL_NAME \
  --model-version $AOAI_MODEL_VERSION \
  -n $AOAI_ACCOUNT_NAME \
  -g $AOAI_RESOURCE_GROUP \
  --deployment-name $AOAI_DEPLOYMENT_NAME

az cognitiveservices account deployment create \
  --model-format $AOAI_MODEL_FORMAT \
  --model-name $AOAI_IMAGE_MODEL_NAME \
  --model-version $AOAI_IMAGE_MODEL_VERSION \
  -n $AOAI_ACCOUNT_NAME \
  -g $AOAI_RESOURCE_GROUP \
  --deployment-name $AOAI_IMAGE_DEPLOYMENT_NAME 

az cognitiveservices account deployment create \
  --model-format $AOAI_MODEL_FORMAT \
  --model-name $AOAI_EMBEDDING_MODEL_NAME \
  --model-version $AOAI_EMBEDDING_MODEL_VERSION \
  -n $AOAI_ACCOUNT_NAME \
  -g $AOAI_RESOURCE_GROUP \
  --deployment-name $AOAI_EMBEDDING_DEPLOYMENT_NAME


export AOAI_ENDPOINT=$(az cognitiveservices account show  -n $AOAI_ACCOUNT_NAME -g $AOAI_RESOURCE_GROUP --query "properties.endpoint" -o tsv)
export AOAI_API_KEY=$(az cognitiveservices account keys list -n $AOAI_ACCOUNT_NAME -g $AOAI_RESOURCE_GROUP --query "key1" -o tsv)

az search service create -n $AZ_AI_SEARCH_NAME \
                         -g $AOAI_RESOURCE_GROUP \
                         --sku $AZ_AI_SEARCH_SKU

# export AZ_AI_SEARCH_API_KEY=$(az search query-key list --service-name $AZ_AI_SEARCH_NAME -g $AOAI_RESOURCE_GROUP --query "[].key" -o tsv)
export AZ_AI_SEARCH_API_KEY=$(az search admin-key show --service-name $AZ_AI_SEARCH_NAME -g $AOAI_RESOURCE_GROUP --query "primaryKey" -o tsv)
export AZ_AI_SEARCH_ENDPOINT="https://"$AZ_AI_SEARCH_NAME".search.windows.net"

