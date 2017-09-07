#!/bin/bash

if [ -z "$USERNAME" ] ; then
  USERNAME=squid
fi

if [ -z "$PASSWORD" ] ; then
  PASSWORD=squid
fi

if [ -z "$HTTP_PORT" ] ; then
  HTTP_PORT=3128
fi

if [ ! -f $squid_conf_file ] ; then
  echo "Missing squid3 configuration file"
  exit 1
fi

# Copy artifact configuration file
if [ ! -f /etc/squid3/squid.conf.default ] ; then
  sudo cp /etc/squid3/squid.conf /etc/squid3/squid.conf.default
  sudo mv $squid_conf_file /etc/squid3/squid.conf
fi

# Override port
if [ "$(grep http_port /etc/squid3/squid.conf 2>/dev/null)" ] ; then
  sudo sed -i "s/http_port [0-9]*/http_port $HTTP_PORT/" /etc/squid3/squid.conf
else
  echo "" | sudo tee -a /etc/squid3/squid.conf
  echo "http_port $HTTP_PORT" | sudo tee -a /etc/squid3/squid.conf
fi

# Add user
sudo htpasswd -b -c /etc/squid3/passwords $USERNAME $PASSWORD
