#!/bin/bash

echo "BEGIN configure mongo"

sudo service mongod stop

echo "change mongo bind ip to ${DB_IP}"
sudo sed -i "s/  bindIp.*/  bindIp: ${DB_IP}/" /etc/mongod.conf

if [ ! -z "$DB_PORT" ] ; then
  echo "change mongo bind port to ${DB_PORT}"
  sudo sed -i "s/  port.*/  port: ${DB_PORT}/" /etc/mongod.conf
fi

echo "END configure mongo"

