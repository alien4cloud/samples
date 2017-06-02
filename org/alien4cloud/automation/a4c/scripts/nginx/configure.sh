#!/bin/bash -e
source $commons/commons.sh
source $commons/ssl.sh
require_envs "LISTEN_PORT SERVER_NAME TARGET_PROTOCOL FRONT_PROTOCOL"

# replace the default web site
sudo cp -f $config/index.html /usr/share/nginx/html/
sudo cp -f $config/alien4cloud-logo.png /usr/share/nginx/html/

if [ "$TARGET_PROTOCOL" == "https" -o "$FRONT_PROTOCOL" == "https" ]; then
  echo "activating SSL on reverse proxy"
  require_envs "CA_PASSPHRASE"

  sudo cp -f $config/nginx.ssl /etc/nginx/sites-enabled/default

  SSL_DIR=/etc/nginx/ssl
  sudo mkdir -p $SSL_DIR

  TMP_SSL_DIR=$( generateKeyAndStore "alien4cloud.github.io" "server" "changeit" "${SERVER_NAME}" )
  sudo cp $TMP_SSL_DIR/server-key.pem $SSL_DIR/server-key.pem
  sudo cp $TMP_SSL_DIR/server-cert.pem $SSL_DIR/server-cert.pem
  sudo rm -rf $TMP_SSL_DIR

  # TEMP_DIR=`mktemp -d`

  # sudo openssl genrsa -out $SSL_DIR/server-key.pem 4096
  # sudo openssl req -subj "/CN=alien4cloud.github.io" -sha256 -new -key $SSL_DIR/server-key.pem -out $TEMP_DIR/server.csr
  # # this cert will be used for the https api
  # sudo echo "subjectAltName = IP:${SERVER_NAME}" > $TEMP_DIR/extfile.cnf
  # sudo openssl x509 -req -days 365 -sha256 \
  #   -in $TEMP_DIR/server.csr -CA $ssl/ca.pem -CAkey $ssl/ca-key.pem \
  #   -CAcreateserial -out $SSL_DIR/server-cert.pem \
  #   -passin pass:${CA_PASSPHRASE} \
  #   -extfile $TEMP_DIR/extfile.cnf

  #   sudo rm -rf $TEMP_DIR
else
  sudo cp -f $config/nginx.default /etc/nginx/sites-enabled/default
fi

sudo sed -i -e "s/%LISTEN_PORT%/${LISTEN_PORT}/g" /etc/nginx/sites-enabled/default
sudo sed -i -e "s/%SERVER_NAME%/${SERVER_NAME}/g" /etc/nginx/sites-enabled/default
