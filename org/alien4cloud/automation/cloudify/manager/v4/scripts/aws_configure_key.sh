#!/bin/bash

# let's generate the input file from the parameters
echo "Generate aws configuration input file."

HOME_DIR=~

echo "agent_keypair_name: '$KEYPAIR_NAME'" >> "$HOME_DIR/cfy_config_aws.yml"
echo "agent_private_key_path: '$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME'" >> "$HOME_DIR/cfy_config_aws.yml"

echo "AWS configuration file has been generated"
