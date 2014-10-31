#!/bin/bash

origPort=80

# Removing previous apache2 installation if exist
sudo rm -rf /var/www/*
sudo apt-get -y -q purge apache2.2-common apache2* || error_exit $? "Failed on: sudo apt-get -y -q purge apache2*"

# The following statements are used since in some cases, there are leftovers after uninstall
sudo rm -rf /etc/apache2 || error_exit $? "Failed on: sudo rm -rf /etc/apache2"
sudo rm -rf /usr/sbin/apache2 || error_exit $? "Failed on: sudo rm -rf /usr/sbin/apache2"
sudo rm -rf /usr/lib/apache2 || error_exit $? "Failed on: sudo rm -rf /usr/lib/apache2"
sudo rm -rf /usr/share/apache2 || error_exit $? "Failed on: sudo rm -rf /usr/share/apache2"

sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"

echo "Using apt-get. Installing apache2 on one of the following : Debian, Ubuntu, Mint"
sudo apt-get install -y -q apache2 || error_exit $? "Failed on: sudo apt-get install -y -q apache2"
docRoot="/var/www"
sudo chmod -R 777 $docRoot

sudo /etc/init.d/apache2 stop

if [[ ("$PORT" == "$origPort") ]]; then
  echo "Use default port for Apache : $origPort"
else
  echo "Replacing port $origPort with $PORT..."
  sudo sed -i -e "s/$origPort/$PORT/g" /etc/apache2/ports.conf || error_exit $? "Failed on: sudo sed -i -e $origPort/$PORT in ports.conf"
fi

sudo /etc/init.d/apache2 start
echo "End of $0"
