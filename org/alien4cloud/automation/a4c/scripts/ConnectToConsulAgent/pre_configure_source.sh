#!/bin/bash -e 
source $commons/commons.sh
source $commons/ssl.sh

require_envs "AGENT_API_PORT AGENT_IP"
# check dependencies
require_bin "openssl"

# a node which is connected to consult will look in this folder
mkdir -p /tmp/a4c/work/${SOURCE_NODE}/ConnectToConsulAgent
echo "${AGENT_API_PORT}" > /tmp/a4c/work/${SOURCE_NODE}/ConnectToConsulAgent/agentAPIPort
echo "${AGENT_IP}" > /tmp/a4c/work/${SOURCE_NODE}/ConnectToConsulAgent/agentIp
echo "${TLS_ENABLED}" > /tmp/a4c/work/${SOURCE_NODE}/ConnectToConsulAgent/TLSEnabled

if [ "$TLS_ENABLED" != "true" ]; then
	exit 0
fi

echo "TLS is enabled, configuring ssl"
require_envs "CA_PASSPHRASE"

SOURCE_SSL_DIR="/tmp/a4c/work/${SOURCE_NODE}/ConnectToConsulAgent/ssl"
mkdir -p "${SOURCE_SSL_DIR}"

SSL_DIR=$( generateKeyAndStore "alient4cloud.org" "client" "changeit" )
echo "changeit" > /tmp/a4c/work/${SOURCE_NODE}/ConnectToConsulAgent/storePwd
echo "client" > /tmp/a4c/work/${SOURCE_NODE}/ConnectToConsulAgent/alias
echo "Generated ssl folder ${SSL_DIR} contains: $(ls ${SSL_DIR})"
echo "Copying ${SSL_DIR} content into ${SOURCE_SSL_DIR}"
sudo cp ${SSL_DIR}/* ${SOURCE_SSL_DIR}/
sudo rm -rf ${SSL_DIR}
