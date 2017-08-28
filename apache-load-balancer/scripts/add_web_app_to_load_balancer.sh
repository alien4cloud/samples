#!/bin/bash

# /etc/apache2/conf.d do not exist in recent apache version
PROXY_BALANCER_CONF_FILE=/etc/apache2/conf.d/proxy-balancer
if [ ! -d "/etc/apache2/conf.d" ]; then
  PROXY_BALANCER_CONF_FILE=/etc/apache2/conf-enabled/proxy-balancer.conf
fi

WEB_APPLICATION_URL="$PROTOCOL://$IP:$PORT/$URL_PATH"

sudo sed -i "/<Proxy balancer:\/\/mycluster>/a BalancerMember $WEB_APPLICATION_URL" $PROXY_BALANCER_CONF_FILE

EXTRA_PROXY_CONFIG="ProxyPass /$URL_PATH balancer://mycluster\nProxyPassReverse /$URL_PATH balancer://mycluster\nProxyPassMatch ^/(.*)\$ balancer://mycluster/\$1"
FIRST_LINE_EXTRA_PROXY_CONFIG="ProxyPass /$URL_PATH balancer://mycluster"

# EXTRA_PROXY_CONFIG should be added only once
if [ -z "`grep "$FIRST_LINE_EXTRA_PROXY_CONFIG" $PROXY_BALANCER_CONF_FILE`" ]; then
    sudo bash -c "echo -e '$EXTRA_PROXY_CONFIG' >> $PROXY_BALANCER_CONF_FILE"
fi

sudo /etc/init.d/apache2 restart
