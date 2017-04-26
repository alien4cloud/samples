#!/bin/bash -e

# Let's pick the right download url based on the selected version.
RPM_URL="http://repository.cloudifysource.org/cloudify/4.0.0/ga-release/cloudify-4.0.0~ga.el6.x86_64.rpm"
sudo timedatectl set-timezone UTC

echo "Download cloudify rpm package from $RPM_URL"

sudo yum -y install gcc libffi-devel python-devel openssl-devel
curl "$RPM_URL" -o ~/cfy.rpm

echo "Installing cloudify CLI"

sudo rpm -i ~/cfy.rpm

HOME_DIR=~
mkdir "$HOME_DIR/cfy_keys"

echo "CLI installation completed"
