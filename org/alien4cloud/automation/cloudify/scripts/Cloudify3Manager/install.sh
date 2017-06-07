#!/bin/bash

# Let's pick the right download url based on the selected version.

RPM_URL="http://repository.cloudifysource.org/org/cloudify3/3.4.2/sp-RELEASE/cloudify-3.4.2~sp-420.el6.x86_64.rpm"
sudo timedatectl set-timezone UTC

echo "Download cloudify rpm package from $RPM_URL"

sudo yum -y install python-setuptools python-wheel python-devel gcc libffi-devel openssl-devel
curl "$RPM_URL" -o ~/cfy.rpm

echo "Installing cloudify CLI"

sudo rpm -i ~/cfy.rpm

echo "CLI installation completed"
