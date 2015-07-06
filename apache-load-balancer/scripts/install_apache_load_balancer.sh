#!/bin/bash

DEFAULT_PORT=80

sudo apt-get update
sudo apt-get install -y -q apache2

sudo /etc/init.d/apache2 stop

if [[ ("$PORT" == "$DEFAULT_PORT") ]]; then
  echo "Use default port for Apache : $DEFAULT_PORT"
else
  echo "Replacing port $DEFAULT_PORT with $PORT..."
  sudo sed -i -e "s/$DEFAULT_PORT/$PORT/g" /etc/apache2/ports.conf || exit ${1}
fi

sudo a2enmod proxy
sudo a2enmod proxy_balancer
sudo a2enmod proxy_http

sudo echo -e "<Proxy balancer://mycluster>\n</Proxy>\nProxyPass / balancer://mycluster/" | sudo tee /etc/apache2/conf.d/proxy-balancer

sudo sed -i 's/Deny from all/Allow from all/g' /etc/apache2/mods-enabled/proxy.conf