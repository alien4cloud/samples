#!/bin/bash -e

# /etc/apache2/conf.d do not exist in recent apache version
PROXY_BALANCER_CONF_FILE=/etc/apache2/conf.d/proxy-balancer
if [ ! -d "/etc/apache2/conf.d" ]; then
  PROXY_BALANCER_CONF_FILE=/etc/apache2/conf-enabled/proxy-balancer.conf
fi

WEB_APPLICATION_URL="$PROTOCOL://$IP:$PORT/$URL_PATH"

WEB_APPLICATION_URL_ESCAPED=$(echo $WEB_APPLICATION_URL | sed -e 's/\\/\\\\/g' -e 's/\//\\\//g' -e 's/&/\\\&/g')

sudo sed -i "/BalancerMember $WEB_APPLICATION_URL_ESCAPED/d" $PROXY_BALANCER_CONF_FILE

sudo /etc/init.d/apache2 restart
