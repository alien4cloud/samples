#!/bin/bash

# let's generate the input file from the parameters
echo "Generate openstack configuration input file."

HOME_DIR=~

echo "  agents_keypair:" >> "$HOME_DIR/cfy_config_openstack.yml"
echo "    name: '$KEYPAIR_NAME'" >> "$HOME_DIR/cfy_config_openstack.yml"
sed -i "1i agent_private_key_path: '/home/cfyuser/$SSH_KEY_FILENAME'" $HOME_DIR/cfy_config_openstack.yml

echo "Openstack configuration file has been generated"