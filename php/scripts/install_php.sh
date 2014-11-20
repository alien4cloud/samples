#!/bin/bash

echo "install PHP..."

# # The following statements are used since in some cases, there are leftovers after uninstall
# sudo apt-get --purge -q -y remove php5* php*
# sudo rm -rf  /etc/php* || error_exit $? "Failed on: sudo rm -rf  /etc/php*"
# sudo rm -rf  /usr/bin/php* || error_exit $? "Failed on: sudo rm -rf  /usr/bin/php"
# sudo rm -rf  /usr/share/php* || error_exit $? "Failed on: sudo rm -rf /usr/share/php"

if [ "$APACHE2_MODULE" == "true" ]; then
  echo "install PHP with Apache2 module..."
  apache2_module="libapache2-mod-php5"
else
  apache2_module=""
fi

if [ "$MYSQL_MODULE" == "true" ]; then
  echo "install PHP with MySQL module..."
  mysql_module="php5-mysql"
else
  mysql_module=""
fi

sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
sudo apt-get -y -q install php5 $apache2_module $mysql_module php5-common php5-curl php5-cli php-pear php5-gd php5-mcrypt php5-xmlrpc php5-sqlite php-xml-parser || error_exit $? "Failed on: sudo apt-get install -y -q php5"

# TODO: Remove the next lines
if type "apache2" > /dev/null; then
  echo "restart Apache2 to launch libapache2-mod-php5"
  sudo /etc/init.d/apache2 restart
fi
