#!/bin/bash -xe

# let's generate the input file from the parameters
echo "Generate configuration input file."

HOME_DIR=~

CERT_DIR=/opt/cfy/cloudify-manager-blueprints/resources/ssl

echo "ssh_user: $SSH_USER" >> "$HOME_DIR/inputs.yml"
echo "ssh_key_filename: $HOME_DIR/cfy_keys/$SSH_KEY_FILENAME" >> "$HOME_DIR/inputs.yml"
echo "agents_user: $AGENTS_USER" >> "$HOME_DIR/inputs.yml"
echo "admin_username: $ADMIN_USERNAME" >> "$HOME_DIR/inputs.yml"
echo "admin_password: $ADMIN_PASSWORD" >> "$HOME_DIR/inputs.yml"
echo "public_ip: $PUBLIC_IP" >> "$HOME_DIR/inputs.yml"
echo "private_ip: $PRIVATE_IP" >> "$HOME_DIR/inputs.yml"
echo "ssl_enabled: true" >> "$HOME_DIR/inputs.yml"

sudo mv "$HOME_DIR/inputs.yml" /opt/cfy/cloudify-manager-blueprints/inputs.yml

echo "Configuration file has been generated"

# generate certificate and key file

echo "Generate a self signed certificate and a private key"

if [ ${SSL_ENABLED} = "true" ]
then
  sudo openssl req -newkey rsa:2048 -nodes -keyout $CERT_DIR/server.key -x509 -days 730 -out $CERT_DIR/server.crt -subj "/C=FR/ST=IDF/L=PARIS/O=alien/CN=example.com"
fi
