#!/bin/bash

echo "install PHP module for Mysql..."
sudo apt-get update || exit ${1}

while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  echo "Waiting for other software managers to finish..."
  sleep 2s
done
sudo apt-get -y -q install php5-mysql || exit ${1}
echo "restart apache2 to launch php5-mysql"
if (( $(ps -ef | grep -v grep | grep apache2 | wc -l) > 0 ))
  then
  sudo /etc/init.d/apache2 restart
else
  sudo /etc/init.d/apache2 start
fi