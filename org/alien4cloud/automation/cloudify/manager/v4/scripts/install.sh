#!/bin/bash

# Let's pick the right download url based on the selected version.

if [ $CFY_VERSION = "4.0.1-ga" ] ; then
  RPM_URL="http://repository.cloudifysource.org/cloudify/4.0.1/sp-release/cloudify-4.0.1~sp.el6.x86_64.rpm"
  sudo timedatectl set-timezone UTC
elif [ $CFY_VERSION = "4.1.0" ] ; then
  RPM_URL="http://repository.cloudifysource.org/cloudify/4.1.0/rc2-release/cloudify-enterprise-cli-4.1rc2.rpm"
  sudo timedatectl set-timezone Europe/Paris
else
  RPM_URL="http://repository.cloudifysource.org/cloudify/4.1.1/ga-release/cloudify-enterprise-cli-4.1.1ga.rpm "
  sudo timedatectl set-timezone Europe/Paris
fi

echo "Download cloudify rpm package from $RPM_URL"

sudo yum -y install gcc libffi-devel python-devel openssl-devel
curl "$RPM_URL" -o ~/cfy.rpm

echo "Installing cloudify CLI"

sudo rpm -i ~/cfy.rpm

# Patch the CLI
if [ $CFY_VERSION = "4.1.1" ] ; then
  sudo mv /opt/cfy/cloudify-manager-blueprints/components/utils.py /opt/cfy/cloudify-manager-blueprints/components/utils.py.default
  sudo cp $cli_utils_script /opt/cfy/cloudify-manager-blueprints/components/utils.py
fi

HOME_DIR=~
mkdir "$HOME_DIR/cfy_keys"
cp ${key_file} "$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME"
chmod 400 "$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME"

echo "CLI installation completed"
