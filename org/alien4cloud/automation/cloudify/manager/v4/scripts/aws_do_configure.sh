#!/bin/bash

echo "Configure AWS"

HOME_DIR=~

# check if the key has been configured (through relationship)
if ! grep -q agent_private_key_path "$HOME_DIR/cfy_config_aws.yml"; then
  echo "Use manager key for aws"

  if [ ! -d "/home/cfyuser" ] ; then
    echo "Create /home/cfyuser"
    sudo mkdir /home/cfyuser
    sudo chmod 700 /home/cfyuser
    sudo chown -R cfyuser:cfyuser /home/cfyuser
  fi

  echo "Copy ssh manager $SSH_KEY_FILENAME into /home/cfyuser"
  sudo cp "$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME" "/home/cfyuser/$SSH_KEY_FILENAME"
  sudo chmod 400 "/home/cfyuser/$SSH_KEY_FILENAME"
  sudo chown -R cfyuser:cfyuser /home/cfyuser/$SSH_KEY_FILENAME

  echo "agent_keypair_name: '$KEYPAIR_NAME'" >> "$HOME_DIR/cfy_config_aws.yml"
  echo "agent_private_key_path: '/home/cfyuser/$SSH_KEY_FILENAME'" >> "$HOME_DIR/cfy_config_aws.yml"
fi

if [ ! -d /etc/cloudify/aws_plugin ]; then
  sudo mkdir /etc/cloudify/aws_plugin
fi

if [ $CFY_VERSION = "4.0.1-ga" ] ; then
  PYTHON_ENV=/opt/manager/env
else 
  PYTHON_ENV=/opt/cfy/embedded
fi
sudo $PYTHON_ENV/bin/python ${python_script} -u $ADMIN_USERNAME -p $ADMIN_PASSWORD --ssl config -c "$HOME_DIR/cfy_config_aws.yml" -i "aws"

echo "AWS configured"
