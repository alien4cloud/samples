#!/bin/bash

echo "install PHP module for Mysql..."
sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
sudo apt-get -y -q install php5-mysql || error_exit $? "Failed on: sudo apt-get install -y -q php5-mysql"

echo "restart apache2 to launch php5-mysql"
sudo /etc/init.d/apache2 restart
