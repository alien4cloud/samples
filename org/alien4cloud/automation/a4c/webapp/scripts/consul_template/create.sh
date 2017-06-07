#!/bin/bash -e
source $commons/commons.sh

# install packages if need
install_dependencies "unzip"

sudo mkdir -p /etc/consul_template/ssl
sudo mkdir -p /var/lib/consul_template/
sudo mkdir -p /var/log/consul_template/

download "consul-template" "${APPLICATION_URL}" /tmp/consul-template.zip
sudo unzip /tmp/consul-template.zip -d /var/lib/consul_template/
sudo rm /tmp/consul-template.zip
