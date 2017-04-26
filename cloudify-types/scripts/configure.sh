#!/bin/bash -e

# let's generate the input file from the parameters
echo "Generate configuration input file."

HOME_DIR=`pwd`

echo "ssh_user: $SSH_USER" >> inputs.yml
echo "ssh_key_filename: $HOME_DIR/cfy_keys/$SSH_KEY_FILENAME" >> inputs.yml
echo "agents_user: $AGENTS_USER" >> inputs.yml
echo "admin_username: $ADMIN_USERNAME" >> inputs.yml
echo "admin_password: $ADMIN_PASSWORD" >> inputs.yml
echo "public_ip: $PUBLIC_IP" >> inputs.yml
echo "private_ip: $PRIVATE_IP" >> inputs.yml

sudo mv inputs.yml /opt/cfy/cloudify-manager-blueprints/inputs.yml

echo "Configuration file has been generated"
