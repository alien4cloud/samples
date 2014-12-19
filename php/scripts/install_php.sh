#!/bin/bash

echo "install PHP5..."

sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  echo "Waiting for other software managers to finish..."
  sleep $[ ( $RANDOM % 10 )  + 2 ]s
done
sudo rm -f /var/lib/dpkg/lock
sudo apt-get -y -q install php5 php5-common php5-curl php5-cli php-pear php5-gd php5-mcrypt php5-xmlrpc php5-sqlite php-xml-parser || error_exit $? "Failed on: sudo apt-get install -y -q php5"
