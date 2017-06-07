#!/bin/bash

# let's generate the input file from the parameters
echo "Generate aws configuration input file."

HOME_DIR=~

echo "aws_access_key: '$AWS_ACCESS_KEY'" >> "$HOME_DIR/cfy_config_aws.yml"
echo "aws_secret_key: '$AWS_SECRET_KEY'" >> "$HOME_DIR/cfy_config_aws.yml"
echo "aws_region: '$AWS_REGION'" >> "$HOME_DIR/cfy_config_aws.yml"
echo "agent_security_group_id: $AGENT_SECURITY_GROUP" >> "$HOME_DIR/cfy_config_aws.yml"
echo "agent_sh_user: $AGENT_SH_USER" >> "$HOME_DIR/cfy_config_aws.yml"

echo "AWS configuration file has been generated"
