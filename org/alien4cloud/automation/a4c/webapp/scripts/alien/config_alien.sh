#!/bin/bash -e
source $commons/commons.sh
source $commons/ssl.sh

require_envs "DATA_DIR SERVER_PROTOCOL ALIEN_PORT"

A4C_CONFIG="/opt/alien4cloud/alien4cloud/config/alien4cloud-config.yml"

# replace the alien data dir
echo "A4C data dir is ${DATA_DIR}"
sudo sed -i -e "s@alien\: \(.*\)@alien\: ${DATA_DIR}@g" ${A4C_CONFIG}
# set the alien port
sudo sed -i -e "s/port\: \(.*\)/port\: $ALIEN_PORT/g" ${A4C_CONFIG}
# set the alien protocol
sudo sed -i -e "s/serverProtocol\: \(.*\)/serverProtocol\: $SERVER_PROTOCOL/g" ${A4C_CONFIG}
# set the admin password
sudo sed -i "s/password: admin/password: ${ADMIN_PASSWORD}/g" ${A4C_CONFIG}
sudo sed -i "s/username: admin/username: ${ADMIN_USERNAME}/g" ${A4C_CONFIG}

if [ "$SERVER_PROTOCOL" == "https" ]; then
  echo "Activating ssl endpoint for Alien webapp"
  # enable SSL
  sudo sed -i -e "s/# ssl\:/ssl\:/g" ${A4C_CONFIG}

  # FIXME: can't be different !!! some confusion somewhere ?
  SERVER_KEYSTORE_PWD="changeit"
  KEY_PWD="${SERVER_KEYSTORE_PWD}"

  TMP_SSL_DIR=$( generateKeyAndStore "alient4cloud.org" "server" "${SERVER_KEYSTORE_PWD}" "${ALIEN_IP}" )

  AC4_SSL_DIR=/etc/alien4cloud/ssl
  sudo mkdir -p $AC4_SSL_DIR

  sudo keytool -importkeystore -destkeystore $AC4_SSL_DIR/server-keystore.jks \
    -srckeystore $TMP_SSL_DIR/server-keystore.p12 -srcstoretype pkcs12 \
    -alias server -deststorepass $SERVER_KEYSTORE_PWD \
    -srckeypass $KEY_PWD -srcstorepass $SERVER_KEYSTORE_PWD

  sudo rm -rf $TMP_SSL_DIR

  sudo sed -i -e "s@#   key-store\: \(.*\)@  key-store\: \"$AC4_SSL_DIR/server-keystore.jks\"@g" ${A4C_CONFIG}
  sudo sed -i -e "s/#   key-store-password\: \(.*\)/  key-store-password\: \"$SERVER_KEYSTORE_PWD\"/g" ${A4C_CONFIG}
  sudo sed -i -e "s/#   key-password\: \(.*\)/  key-password\: \"$KEY_PWD\"/g" ${A4C_CONFIG}
fi

# get the ES address list
if [ -f /tmp/a4c/work/${NODE}/es_list ]; then
  es_list=$(</tmp/a4c/work/${NODE}/es_list)
fi

if [ -z "$es_list" ]; then
  echo "Not connected to any ES cluster"
  sudo sed -i -e "s/client\: \(.*\)/client\: false/g" ${A4C_CONFIG}
  sudo sed -i -e "s/transportClient\: \(.*\)/transportClient\: false/g" ${A4C_CONFIG}
else
  echo "A4C is connected to remote ElasticSearch ${es_list}"
  sudo sed -i -e "s/client\: \(.*\)/client\: true/g" ${A4C_CONFIG}
  sudo sed -i -e "s/# transportClient\: \(.*\)/transportClient\: true/g" ${A4C_CONFIG}
  # set the elsaticsearch hosts
  sudo sed -i -e "s/# hosts\: \(.*\)/hosts\: $es_list/g" ${A4C_CONFIG}

  # get the cluster name
  cluster_name=$(</tmp/a4c/work/${NODE}/cluster_name)
  echo "The ElasticSearch cluster is: ${cluster_name}"
  # replace the cluster name in alien config
  sudo sed -i -e "s/clusterName\: \(.*\)/clusterName\: $cluster_name/g" ${A4C_CONFIG}
  sudo bash -c 'echo "cluster.name: ${cluster_name}" > /opt/alien4cloud/alien4cloud/config/elasticsearch.yml'
fi

# enable HA if A4C is connected to a Consul agent
if [ -d "/tmp/a4c/work/${NODE}/ConnectToConsulAgent" ]; then
  AGENT_API_PORT=$(</tmp/a4c/work/${NODE}/ConnectToConsulAgent/agentAPIPort)
  AGENT_IP=$(</tmp/a4c/work/${NODE}/ConnectToConsulAgent/agentIp)

  echo "A4C is connected to Consul ${AGENT_IP}:${AGENT_API_PORT}, activate HA"
  sudo sed -i -e "s/ha_enabled\: \(.*\)/ha_enabled\: true/g" ${A4C_CONFIG}
  sudo sed -i -e "s/consulAgentIp\: \(.*\)/consulAgentIp\: ${AGENT_IP}/g" ${A4C_CONFIG}
  sudo sed -i -e "s/consulAgentPort\: \(.*\)/consulAgentPort\: ${AGENT_API_PORT}/g" ${A4C_CONFIG}
  sudo sed -i -e "s/#\(.*\)consulAgentIp\: \(.*\)/consulAgentIp\: ${AGENT_IP}/g" ${A4C_CONFIG}
  sudo sed -i -e "s/#\(.*\)consulAgentPort\: \(.*\)/consulAgentPort\: ${AGENT_API_PORT}/g" ${A4C_CONFIG}
  # set the alien IP for consul checks
  sudo sed -i -e "s/instanceIp\: \(.*\)/instanceIp\: $ALIEN_IP/g" ${A4C_CONFIG}

  TLS_ENABLED=$(</tmp/a4c/work/${NODE}/ConnectToConsulAgent/TLSEnabled)
  if [ "$TLS_ENABLED" == "true" ]; then
      echo "Activating TLS to be able to speak to Consul agent"
      require_bin "keytool"

      SSL_STORE_PATH="/etc/alien4cloud/consul/ssl"
      sudo mkdir -p $SSL_STORE_PATH
      SSL_DIR="/tmp/a4c/work/${NODE}/ConnectToConsulAgent/ssl"

      KEY_ALIAS=$(</tmp/a4c/work/${NODE}/ConnectToConsulAgent/alias)
      STORE_PWD=$(</tmp/a4c/work/${NODE}/ConnectToConsulAgent/storePwd)

      # here we need to create java compliant keystores ...
      echo "Using keytoool to generate a jks client keystore"
      sudo keytool -importkeystore -destkeystore $SSL_STORE_PATH/client-keystore.jks \
          -srckeystore $SSL_DIR/$KEY_ALIAS-keystore.p12 -srcstoretype pkcs12 \
          -alias ${KEY_ALIAS} -deststorepass "${STORE_PWD}" \
          -srckeypass "${STORE_PWD}" -srcstorepass "${STORE_PWD}" 2>&1
      ensure_success "Using keytoool to generate a jks client keystore"

      sudo keytool -import -alias ${KEY_ALIAS} -keystore $SSL_STORE_PATH/truststore.jks \
          -file $SSL_DIR/ca.csr -storepass "${STORE_PWD}" -noprompt

      # FIXME: for the moment the securised client agent only listen on 127.0.0.1
      sudo sed -i -e "s/consulAgentIp\: \(.*\)/consulAgentIp\: 127.0.0.1/g" ${A4C_CONFIG}
      sudo sed -i -e "s/consul_tls_enabled\: \(.*\)/consul_tls_enabled\: true/g" ${A4C_CONFIG}
      sudo sed -i -e "s@keyStorePath\: \(.*\)@keyStorePath\: $SSL_STORE_PATH/client-keystore.jks@g" ${A4C_CONFIG}
      sudo sed -i -e "s@trustStorePath\: \(.*\)@trustStorePath\: $SSL_STORE_PATH/truststore.jks@g" ${A4C_CONFIG}
      sudo sed -i -e "s/keyStoresPwd\: \(.*\)/keyStoresPwd\: changeit/g" ${A4C_CONFIG}
  else
      sudo sed -i -e "s/consul_tls_enabled\: \(.*\)/consul_tls_enabled\: false/g" ${A4C_CONFIG}
  fi
else
  echo "A4C is not connected to Consul, desactivate HA"
  sudo sed -i -e "s/ha_enabled\: \(.*\)/ha_enabled\: false/g" ${A4C_CONFIG}
fi
################## a4c service ###############################

sudo bash -c "sed -e 's/\\\${APP_ARGS}/${APP_ARGS}/' $bin/alien.sh > /etc/init.d/alien"
sudo chmod +x /etc/init.d/alien

sudo update-rc.d alien defaults 95 10
