#!/bin/bash

# let's generate the input file from the parameters
echo "Generate azure configuration input file."

HOME_DIR=~

echo "subscription_id: '$SUBSCRIPTION_ID'" >> "$HOME_DIR/cfy_config_azure.yml"
echo "tenant_id: '$TENANT_ID'" >> "$HOME_DIR/cfy_config_azure.yml"
echo "client_id: '$CLIENT_ID'" >> "$HOME_DIR/cfy_config_azure.yml"
echo "client_secret: '$CLIENT_SECRET'" >> "$HOME_DIR/cfy_config_azure.yml"
echo "location: '$LOCATION'" >> "$HOME_DIR/cfy_config_azure.yml"
# echo "agent_security_group_id: $AGENT_SECURITY_GROUP" >> "$HOME_DIR/cfy_config_azure.yml"
echo "agent_sh_user: $AGENT_SH_USER" >> "$HOME_DIR/cfy_config_azure.yml"

echo "Azure configuration file has been generated"
