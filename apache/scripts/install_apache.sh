#!/bin/bash

defaultPort=80
defaultPath="/var/www/"

# Removing previous apache2 installation if exist
sudo rm -rf $defaultPath*
sudo apt-get -y -q purge apache2.2-common apache2* || error_exit $? "Failed on: sudo apt-get -y -q purge apache2*"

# The following statements are used since in some cases, there are leftovers after uninstall
sudo rm -rf /etc/apache2 || error_exit $? "Failed on: sudo rm -rf /etc/apache2"
sudo rm -rf /usr/sbin/apache2 || error_exit $? "Failed on: sudo rm -rf /usr/sbin/apache2"
sudo rm -rf /usr/lib/apache2 || error_exit $? "Failed on: sudo rm -rf /usr/lib/apache2"
sudo rm -rf /usr/share/apache2 || error_exit $? "Failed on: sudo rm -rf /usr/share/apache2"

echo "Using apt-get. Installing apache2 on one of the following : Debian, Ubuntu, Mint"
sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
sudo apt-get install -y -q apache2 || error_exit $? "Failed on: sudo apt-get install -y -q apache2"
eval "chown -R www-data:www-data $defaultPath"

sudo /etc/init.d/apache2 stop

if [[ ("$PORT" == "$defaultPort") ]]; then
  echo "Use default port for Apache : $defaultPort"
else
  echo "Replacing port $defaultPort with $PORT..."
  sudo sed -i -e "s/$defaultPort/$PORT/g" /etc/apache2/ports.conf || error_exit $? "Failed on: sudo sed -i -e $defaultPort/$PORT in ports.conf"
fi

echo "ServerName localhost" >> /etc/apache2/apache2.conf

sudo /etc/init.d/apache2 start
echo "End of $0"
