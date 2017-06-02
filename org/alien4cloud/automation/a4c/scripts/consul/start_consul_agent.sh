#!/bin/bash -e
source $commons/commons.sh
source $commons/ssl.sh

require_envs "CONSUL_DATA_DIR,INSTANCE,CONSUL_BIND_ADDRESS,CONSUL_API_PORT"

echo "Starting consul agent on ${CONSUL_BIND_ADDRESS}"

# evaluate and put the basic config
eval_conf_file $configs/basic_config.json /etc/consul/01_basic_config.json "CONSUL_DATA_DIR,INSTANCE,CONSUL_BIND_ADDRESS,CONSUL_API_PORT"

if [ "$CONSUL_AGENT_MODE" == "server" ]; then
  BOOTSTRAP_EXPECT=$(echo ${INSTANCES} | tr ',' ' ' | wc -w)
	# evaluate and put the server config
  eval_conf_file $configs/server_config.json /etc/consul/02_server_config.json "BOOTSTRAP_EXPECT"
fi

if [ ! -z "$ENCRYPT_KEY" ]; then
  eval_conf_file $configs/encrypt_config.json /etc/consul/03_encrypt_config.json "ENCRYPT_KEY"
fi

if [ "$TLS_ENABLED" == "true" ]; then

  TEMP_DIR=`mktemp -d`

	# evaluate and put the secured config
  eval_conf_file $configs/${CONSUL_AGENT_MODE}_secured_config.json /etc/consul/04_${CONSUL_AGENT_MODE}_secured_config.json "CONSUL_API_PORT"

  # generate key and certificates signed with the CA
	SSL_REPO=/etc/consul/ssl
  TMP_SSL_DIR=$( generateKeyAndStore "alient4cloud.org" "${CONSUL_AGENT_MODE}" "${SERVER_KEYSTORE_PWD}" "127.0.0.1" )
	sudo cp $TMP_SSL_DIR/ca.pem $SSL_REPO/ca.pem
	sudo cp $TMP_SSL_DIR/${CONSUL_AGENT_MODE}-key.pem $SSL_REPO/${CONSUL_AGENT_MODE}-key.pem
	sudo cp $TMP_SSL_DIR/${CONSUL_AGENT_MODE}-cert.pem $SSL_REPO/${CONSUL_AGENT_MODE}-cert.pem
  sudo rm -rf $TMP_SSL_DIR
fi

echo "Start consul agent in ${CONSUL_AGENT_MODE} mode, expecting ${BOOTSTRAP_EXPECT} servers, data dir at ${CONSUL_DATA_DIR}, bind on interface ${CONSUL_BIND_ADDRESS}"

nohup sudo bash -c 'consul agent -ui -config-dir /etc/consul > /var/log/consul/consul.log 2>&1 &' >> /dev/null 2>&1 &

sleep 2
echo "Consul has following members until now"
sudo consul members

# export API_PORT=:8500
# export CONSUL_SERVER_ADDRESS=${CONSUL_BIND_ADDRESS}:8301
# export CONSUL_CLIENT_ADDRESS=${CONSUL_BIND_ADDRESS}:${API_PORT}
