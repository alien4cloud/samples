#!/bin/bash -e

service="apache2"
echo "Stopping apache2"
sudo /etc/init.d/$service stop
echo "Uninstalling apache2"
sudo sudo apt-get autoremove --purge  -y -q apache2 || exit ${1}

