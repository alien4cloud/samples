#!/bin/bash

HOME_DIR=~
mkdir "$HOME_DIR/cfy_keys"
cp ${key_file} "$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME"
chmod 400 "$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME"

# let's generate the input file from the parameters
echo "Generate configuration input file."

chmod +x ${resources}/update_rabbitmq_ssl_keys.py
${resources}/update_rabbitmq_ssl_keys.py -src ${resources}/sg-simple-manager-blueprint-inputs.yaml
sudo cp /tmp/cert.pem /opt/cfy/cloudify-manager-blueprints/resources/ssl/server.crt
sudo cp /tmp/key.pem /opt/cfy/cloudify-manager-blueprints/resources/ssl/server.key

INPUT_PATH=/opt/cfy/cloudify-manager-blueprints/inputs.yml
sudo mv "${resources}/sg-simple-manager-blueprint-inputs.yaml" $INPUT_PATH

sudo sed -i -e "s/%ADMIN_USERNAME%/${ADMIN_USERNAME}/g" $INPUT_PATH
sudo sed -i -e "s/%ADMIN_PASSWORD%/${ADMIN_PASSWORD}/g" $INPUT_PATH
sudo sed -i -e "s/%PUBLIC_IP%/${PUBLIC_IP}/g" $INPUT_PATH
sudo sed -i -e "s/%PRIVATE_IP%/${PRIVATE_IP}/g" $INPUT_PATH
sudo sed -i -e "s/%SSH_USER%/${SSH_USER}/g" $INPUT_PATH
sudo sed -i -e "s/%AGENTS_USER%/${AGENTS_USER}/g" $INPUT_PATH
SSH_KEY_PATH="$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME"
sudo sed -i -e "s@%SSH_KEY_PATH%@${SSH_KEY_PATH}@g" $INPUT_PATH
sudo sed -i -e "s/%RABBITMQ_USER%/${RABBITMQ_USER}/g" $INPUT_PATH
sudo sed -i -e "s/%RABBITMQ_PASSWORD%/${RABBITMQ_PASSWORD}/g" $INPUT_PATH


echo "Configuration file has been generated"

echo "Generate a self signed certificate and a private key"

CERT_DIR=/opt/cfy/cloudify-manager-blueprints/resources/ssl
sudo openssl req -newkey rsa:2048 -nodes -keyout $CERT_DIR/server.key -x509 -days 730 -out $CERT_DIR/server.crt -subj "/C=FR/ST=IDF/L=PARIS/O=alien/CN=example.com"

echo "Key generated"
