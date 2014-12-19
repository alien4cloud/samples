#!/bin/bash

defaultPort=80

# Removing previous apache2 installation if exist
sudo rm -rf $DOC_ROOT*
sudo apt-get -y -q purge apache2.2-common apache2* || error_exit $? "Failed on: sudo apt-get -y -q purge apache2*"

# The following statements are used since in some cases, there are leftovers after uninstall
sudo rm -rf /etc/apache2 || error_exit $? "Failed on: sudo rm -rf /etc/apache2"
sudo rm -rf /usr/sbin/apache2 || error_exit $? "Failed on: sudo rm -rf /usr/sbin/apache2"
sudo rm -rf /usr/lib/apache2 || error_exit $? "Failed on: sudo rm -rf /usr/lib/apache2"
sudo rm -rf /usr/share/apache2 || error_exit $? "Failed on: sudo rm -rf /usr/share/apache2"

echo "Using apt-get. Installing apache2 on one of the following : Debian, Ubuntu, Mint"
sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"

while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  echo "Waiting for other software managers to finish..."
  sleep $[ ( $RANDOM % 10 )  + 2 ]s
done
sudo rm -f /var/lib/dpkg/lock
sudo apt-get install -y -q apache2 || error_exit $? "Failed on: sudo apt-get install -y -q apache2"
sudo /etc/init.d/apache2 stop

if [ ! -d $DOC_ROOT ]; then
  eval "sudo mkdir -p $DOC_ROOT"
fi
eval "sudo chown -R www-data:www-data $DOC_ROOT"

if [[ ("$PORT" == "$defaultPort") ]]; then
  echo "Use default port for Apache : $defaultPort"
else
  echo "Replacing port $defaultPort with $PORT..."
  sudo sed -i -e "s/$defaultPort/$PORT/g" /etc/apache2/ports.conf || error_exit $? "Failed on: sudo sed -i -e $defaultPort/$PORT in ports.conf"
fi

echo "Change config of apache2"
if sudo test -f /etc/apache2/sites-available/default; then
  echo "Change the DocumentRoot of apache2 on Ubuntu < 14.04"
  sudo sed -i -e "s#DocumentRoot /var/www#DocumentRoot $DOC_ROOT#g" /etc/apache2/sites-available/default
fi
if sudo test -f /etc/apache2/sites-available/000-default.conf; then
  echo "Change the DocumentRoot of Apache2 on Ubuntu >= 14.04"
  sudo sed -i -e "s#DocumentRoot /var/www/html#DocumentRoot $DOC_ROOT#g" /etc/apache2/sites-available/000-default.conf
fi

sudo echo "ServerName localhost" >> /etc/apache2/apache2.conf

echo "Start apache2 whith new conf"
sudo /etc/init.d/apache2 start
echo "End of $0"
