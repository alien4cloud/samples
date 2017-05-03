#!/bin/bash -e

# let's generate the input file from the parameters
echo "Generate configuration input file."

HOME_DIR=~

echo "ssh_user: $SSH_USER" >> "$HOME_DIR/inputs.yml"
echo "ssh_key_filename: $HOME_DIR/cfy_keys/$SSH_KEY_FILENAME" >> "$HOME_DIR/inputs.yml"
echo "agents_user: $AGENTS_USER" >> "$HOME_DIR/inputs.yml"
echo "admin_username: $ADMIN_USERNAME" >> "$HOME_DIR/inputs.yml"
echo "admin_password: $ADMIN_PASSWORD" >> "$HOME_DIR/inputs.yml"
echo "public_ip: $PUBLIC_IP" >> "$HOME_DIR/inputs.yml"
echo "private_ip: $PRIVATE_IP" >> "$HOME_DIR/inputs.yml"

sudo mv "$HOME_DIR/inputs.yml" /opt/cfy/cloudify-manager-blueprints/inputs.yml

echo "Configuration file has been generated"
