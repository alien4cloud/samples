#!/bin/bash

echo "install PHP module for Mysql..."
sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"

while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  echo "Waiting for other software managers to finish..."
  sleep $[ ( $RANDOM % 10 )  + 2 ]s
done
sudo apt-get -y -q install php5-mysql || error_exit $? "Failed on: sudo apt-get install -y -q php5-mysql"

echo "restart apache2 to launch php5-mysql"
if (( $(ps -ef | grep -v grep | grep apache2 | wc -l) > 0 ))
  then
  sudo /etc/init.d/apache2 restart
else
  sudo /etc/init.d/apache2 start
fi
