#!/bin/bash

echo "Configure AZURE"

HOME_DIR=~

# check if the key has been configured (through relationship)
if ! grep -q agent_private_key_path "$HOME_DIR/cfy_config_azure.yml"; then
  echo "Use manager key for aws"
  echo "agent_keypair_name: '$KEYPAIR_NAME'" >> "$HOME_DIR/cfy_config_azure.yml"
  echo "agent_private_key_path: '$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME'" >> "$HOME_DIR/cfy_config_azure.yml"
fi

if [ $CFY_VERSION = "4.0.1-ga" ] ; then
  PYTHON_ENV=/opt/manager/env
else 
  PYTHON_ENV=/opt/cfy/embedded
fi
sudo $PYTHON_ENV/bin/python ${python_script} -u $ADMIN_USERNAME -p $ADMIN_PASSWORD --ssl config -c "$HOME_DIR/cfy_config_azure.yml" -i "azure"

echo "AZURE configured"

# modify a file so we can access the manager via the webui

sudo sed -i -e '$a\NODE_TLS_REJECT_UNAUTHORIZED=0' /etc/sysconfig/cloudify-stage
sudo systemctl restart cloudify-stage
