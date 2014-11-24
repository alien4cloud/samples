#!/bin/bash

echo "install PHP5..."

sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
sudo apt-get -y -q install php5 php5-common php5-curl php5-cli php-pear php5-gd php5-mcrypt php5-xmlrpc php5-sqlite php-xml-parser || error_exit $? "Failed on: sudo apt-get install -y -q php5"
