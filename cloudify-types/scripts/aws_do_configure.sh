#!/bin/bash -xe

echo "Configure AWS"

HOME_DIR=~

# check if the key has been configured (through relationship)
if ! grep -q agent_private_key_path "$HOME_DIR/cfy_config_aws.yml"; then
  echo "Use manager key for aws"
  echo "agent_keypair_name: '$KEYPAIR_NAME'" >> "$HOME_DIR/cfy_config_aws.yml"
  echo "agent_private_key_path: '$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME'" >> "$HOME_DIR/cfy_config_aws.yml"
fi

if [ ! -d /etc/cloudify/aws_plugin ]; then
  sudo mkdir /etc/cloudify/aws_plugin
fi

<<<<<<< HEAD
  sudo /opt/manager/env/bin/python ${python_script} -u $ADMIN_USERNAME -p $ADMIN_PASSWORD --ssl config -c "$HOME_DIR/cfy_config_aws.yml" -i $IAAS
=======
sudo /opt/manager/env/bin/python ${python_script} -u $ADMIN_USERNAME -p $ADMIN_PASSWORD --ssl config -c "$HOME_DIR/cfy_config_aws.yml" -i "aws"
>>>>>>> a253c09e142f1908fbe8e0b6bc886a547d7b526f

echo "AWS configured"

# modify a file so we can access the manager via the webui
<<<<<<< HEAD

sudo sed -i -e '$a\NODE_TLS_REJECT_UNAUTHORIZED=0' /etc/sysconfig/cloudify-stage
sudo systemctl restart cloudify-stage


=======
sudo sed -i -e '$a\NODE_TLS_REJECT_UNAUTHORIZED=0' /etc/sysconfig/cloudify-stage
sudo systemctl restart cloudify-stage
>>>>>>> a253c09e142f1908fbe8e0b6bc886a547d7b526f
