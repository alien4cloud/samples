#!/bin/bash -e

echo "restart apache2 to launch php5-mysql"
if (( $(ps -ef | grep -v grep | grep apache2 | wc -l) > 0 ))
  then
  sudo /etc/init.d/apache2 restart
else
  sudo /etc/init.d/apache2 start
fi
