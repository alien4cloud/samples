#!/bin/bash -e
source $commons/commons.sh
require_bin "openssl"
require_envs "LISTEN_PORT SERVER_NAME FRONT_PROTOCOL TARGET_PROTOCOL"

CONF_PATH="/etc/consul_template"

if ! [ -d "/tmp/a4c/work/${NODE}/ConnectToConsulAgent" ]; then
	echo "Should find a dir /tmp/a4c/work/${NODE}/ConnectToConsulAgent, aborting" >&2
	exit 1
fi
AGENT_API_PORT=$(</tmp/a4c/work/${NODE}/ConnectToConsulAgent/agentAPIPort)
AGENT_IP=$(</tmp/a4c/work/${NODE}/ConnectToConsulAgent/agentIp)
TLS_ENABLED=$(</tmp/a4c/work/${NODE}/ConnectToConsulAgent/TLSEnabled)
require_envs "AGENT_API_PORT AGENT_IP TLS_ENABLED"

# generate the nginx config template
TEMPLATE_PATH="${CONF_PATH}/nginx.conf.ctpl"
sudo cp $config/nginx.conf.ctpl ${TEMPLATE_PATH}
if [ "$FRONT_PROTOCOL" == "https" ]; then
	sudo cp $config/nginx.ssl.ctpl ${TEMPLATE_PATH}
fi

sudo sed -i -e "s/%LISTEN_PORT%/${LISTEN_PORT}/g" $TEMPLATE_PATH
sudo sed -i -e "s/%SERVER_NAME%/${SERVER_NAME}/g" $TEMPLATE_PATH
sudo sed -i -e "s/%FRONT_PROTOCOL%/${FRONT_PROTOCOL}/g" $TEMPLATE_PATH
sudo sed -i -e "s/%TARGET_PROTOCOL%/${TARGET_PROTOCOL}/g" $TEMPLATE_PATH

# evaluate and put the consul-template config
sudo cp $config/consul_template.conf $CONF_PATH/consul_template.conf
sudo sed -i -e "s/%TLS_ENABLED%/${TLS_ENABLED}/g" $CONF_PATH/consul_template.conf
sudo sed -i -e "s/%AGENT_API_PORT%/${AGENT_API_PORT}/g" $CONF_PATH/consul_template.conf

# generate certificates if TLS is enabled
if [ "$TLS_ENABLED" == "true" ]; then
	# FIXME: in secured mode only 127.0.0.1 is binded
	sudo sed -i -e "s/%AGENT_IP%/127.0.0.1/g" $CONF_PATH/consul_template.conf

	SSL_REPO=$CONF_PATH/ssl

	SSL_DIR="/tmp/a4c/work/${NODE}/ConnectToConsulAgent/ssl"

	KEY_ALIAS=$(</tmp/a4c/work/${NODE}/ConnectToConsulAgent/alias)
	sudo cp $SSL_DIR/$KEY_ALIAS-key.pem $SSL_REPO/client-key.pem
	sudo cp $SSL_DIR/ca.pem $SSL_REPO/ca.pem
	sudo cp $SSL_DIR/$KEY_ALIAS-cert.pem $SSL_REPO/client-cert.pem
	sudo rm -rf $SSL_DIR

else
	sudo sed -i -e "s/%AGENT_IP%/${AGENT_IP}/g" $CONF_PATH/consul_template.conf
fi


echo "Content of $CONF_PATH/consul_template.conf"
sudo cat $CONF_PATH/consul_template.conf
