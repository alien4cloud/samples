#!/bin/bash

echo "Debian based MYSQL install 5..."
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update && apt-get -yq install mysql-server-5.5 pwgen
sudo /etc/init.d/mysql stop
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf /var/lib/mysql/*
echo "MySQL Installation complete."
