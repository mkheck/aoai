#!/bin/bash
# Author  : Mark A. Heckler
# Notes   : This script either deletes all resources in this resource group (default) or 
#         : just the OpenAI Cognitive Services account (if commented command is uncommented & vice versa).
#         : Must have run 'source aoaicreate.sh' first for env vars.
# History : 20240429 Official "version 1"
#         : 20240830 Added optional delete command for only Azure AI Search


# Delete only the OpenAI account
# az cognitiveservices account delete -n $AOAI_ACCOUNT_NAME -g $AOAI_RESOURCE_GROUP


# Burn it ALL down 🔥
az group delete -g $AOAI_RESOURCE_GROUP -y


# Delete only the Azure AI Search Service instance
# az search service delete -n $AZ_AI_SEARCH_NAME \
#                          -g $AOAI_RESOURCE_GROUP
