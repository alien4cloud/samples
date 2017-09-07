#!/bin/bash -e

sudo apt-get -y update
sudo apt-get -y install squid apache2-utils

if (( $(ps -ef | grep -v grep | grep squid3 | wc -l) > 0 ))
then
  sudo service squid3 stop
fi