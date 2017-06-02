#!/bin/bash -e
source $commons/commons.sh
source $commons/ssl.sh
install_dependencies "unzip"
require_envs "CONSUL_DOWNLOAD_URL"

if [ ! -d "/etc/consul/ssl" ]; then
  sudo mkdir -p /etc/consul/ssl
fi
if [ ! -d "/var/log/consul" ]; then
  sudo mkdir -p /var/log/consul
fi
if [ ! -d "$CONSUL_DATA_DIR" ]; then
  sudo mkdir -p ${CONSUL_DATA_DIR}
fi

CONSUL_TMP_ZIP=/tmp/consul.zip
download "consul" "${CONSUL_DOWNLOAD_URL}" ${CONSUL_TMP_ZIP}

echo "Unzipping consul package to /usr/local/bin"
sudo unzip -o ${CONSUL_TMP_ZIP} -d /usr/local/bin
echo "Unzipped consul package to /usr/local/bin"

install_CAcertificate $ssl/ca.pem

sudo rm ${CONSUL_TMP_ZIP}
