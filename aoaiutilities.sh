#!/bin/bash
# Author  : Mark A. Heckler
# Notes   : This is just a collection of useful commands.
#         : Must have run 'source aoaicreate.sh' first for env vars.
#         : Each command is really intended to be copy/pasted into a shell, not run as a script. 
# History : 20240429 Official "version 1"


### UTILITY COMMANDS ###

# List available kinds of cognitive services accounts
az cognitiveservices account list-kinds

# List all available models in the specified location
az cognitiveservices model list -l $AOAI_LOCATION

# Show the deployment status
az cognitiveservices account deployment show -g $AOAI_RESOURCE_GROUP -n $AOAI_ACCOUNT_NAME --deployment-name $AOAI_DEPLOYMENT_NAME

# Show the endpoint (used above to assign env var)
az cognitiveservices account show  -n $AOAI_ACCOUNT_NAME -g $AOAI_RESOURCE_GROUP --query "properties.endpoint" -o tsv

# List the first key for the account and strip the quotes (used above to assign env var)
az cognitiveservices account keys list -n $AOAI_ACCOUNT_NAME -g $AOAI_RESOURCE_GROUP --query "key1" -o tsv
