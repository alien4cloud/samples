#!/bin/bash -xe

# Let's pick the right download url based on the selected version.

RPM_URL="http://repository.cloudifysource.org/cloudify/4.0.1/sp-release/cloudify-4.0.1~sp.el6.x86_64.rpm"
sudo timedatectl set-timezone UTC

echo "Download cloudify rpm package from $RPM_URL"

sudo yum -y install gcc libffi-devel python-devel openssl-devel
curl "$RPM_URL" -o ~/cfy.rpm

echo "Installing cloudify CLI"

sudo rpm -i ~/cfy.rpm

HOME_DIR=~
mkdir "$HOME_DIR/cfy_keys"
cp ${key_file} "$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME"

echo "CLI installation completed"
