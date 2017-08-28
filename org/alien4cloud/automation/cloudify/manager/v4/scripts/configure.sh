#!/bin/bash

# let's generate the input file from the parameters
echo "Generate configuration input file."

HOME_DIR=~

if [ -z "$PUBLIC_IP" ] ; then
  echo "Public ip not found. Use the private ip instead..."
  PUBLIC_IP=$PRIVATE_IP
fi

echo "ssh_user: $SSH_USER" >> "$HOME_DIR/inputs.yml"
echo "ssh_key_filename: $HOME_DIR/cfy_keys/$SSH_KEY_FILENAME" >> "$HOME_DIR/inputs.yml"
echo "agents_user: $AGENTS_USER" >> "$HOME_DIR/inputs.yml"
echo "admin_username: $ADMIN_USERNAME" >> "$HOME_DIR/inputs.yml"
echo "admin_password: $ADMIN_PASSWORD" >> "$HOME_DIR/inputs.yml"
echo "public_ip: $PUBLIC_IP" >> "$HOME_DIR/inputs.yml"
echo "private_ip: $PRIVATE_IP" >> "$HOME_DIR/inputs.yml"
echo "ssl_enabled: true" >> "$HOME_DIR/inputs.yml"


if [ $CFY_VERSION = "4.0.1-ga" ] ; then
  echo "manager_resources_package: http://repository.cloudifysource.org/cloudify/4.1.0/rc2-release/cloudify-enterprise-manager-resources-4.1rc2.gz" >> "$HOME_DIR/inputs.yml"
elif [ $CFY_VERSION = "4.1.0" ] ; then
  echo "manager_resources_package: http://repository.cloudifysource.org/cloudify/4.0.1/sp-release/cloudify-manager-resources_4.0.1-sp.tar.gz" >> "$HOME_DIR/inputs.yml"
else
  echo "manager_resources_package: http://repository.cloudifysource.org/cloudify/4.1.1/ga-release/cloudify-manager-resources_4.1.1-ga.tar.gz" >> "$HOME_DIR/inputs.yml"
fi

sudo mv "$HOME_DIR/inputs.yml" /opt/cfy/cloudify-manager-blueprints/inputs.yml

echo "Configuration file has been generated"

echo "Generate a self signed certificate and a private key"

CERT_DIR=/opt/cfy/cloudify-manager-blueprints/resources/ssl
sudo openssl req -newkey rsa:2048 -nodes -keyout $CERT_DIR/server.key -x509 -days 730 -out $CERT_DIR/server.crt -subj "/C=FR/ST=IDF/L=PARIS/O=alien/CN=example.com"

echo "Key generated"
