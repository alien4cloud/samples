#!/bin/bash

echo "Configure Openstack"

HOME_DIR=~

# check if the key has been configured (through relationship)
if ! grep -q agent_private_key_path "$HOME_DIR/cfy_config_openstack.yml"; then
  echo "Use manager key for openstack"

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

  echo "  agents_keypair:" >> "$HOME_DIR/cfy_config_openstack.yml"
  echo "    name: '$KEYPAIR_NAME'" >> "$HOME_DIR/cfy_config_openstack.yml"

  sed -i "1i agent_private_key_path: '/home/cfyuser/$SSH_KEY_FILENAME'" $HOME_DIR/cfy_config_openstack.yml
fi

if [ ! -d /etc/cloudify/openstack_plugin ]; then
  sudo mkdir /etc/cloudify/openstack_plugin
fi

sudo /opt/manager/env/bin/python ${python_script} -u $ADMIN_USERNAME -p $ADMIN_PASSWORD --ssl config -c "$HOME_DIR/cfy_config_openstack.yml" -i "openstack"

echo "Openstack configured"
