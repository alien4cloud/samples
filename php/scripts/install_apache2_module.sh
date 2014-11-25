#!/bin/bash

echo "install PHP module for Apache2..."
sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
sudo apt-get -y -q install libapache2-mod-php5 || error_exit $? "Failed on: sudo apt-get install -y -q libapache2-mod-php5"

echo "restart Apache2 to launch libapache2-mod-php5"
sudo /etc/init.d/apache2 restart
