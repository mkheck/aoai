#!/bin/bash
# Author  : Mark A. Heckler
# Notes   : This script either deletes all resources in this resource group (default) or 
#         : just the OpenAI Cognitive Services account (if commented command is uncommented & vice versa).
#         : Must have run 'source aoaicreate.sh' first for env vars.
# History : 20240429 Official "version 1"

# Delete only the OpenAI account
# az cognitiveservices account delete -n $AOAI_ACCOUNT_NAME -g $AOAI_RESOURCE_GROUP

# -- or --

# Burn it ALL down 🔥 (default)
az group delete -g $AOAI_RESOURCE_GROUP -y
