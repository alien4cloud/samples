#!/bin/bash

while [ ! -f /tmp/mysql.conf ]
do
  sleep 2
done

source /tmp/mysql.conf

if ! type "unzip" > /dev/null; then
  echo "Install unzip..."
  sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
  sudo apt-get install unzip || error_exit $? "Failed on: sudo apt-get install unzip"
fi

DOC_ROOT="/var/www/html"
echo "Dowload and unzip the last build of Wordpress..."
eval "wget $WEBFILE_URL"

nameZip=${WEBFILE_URL##*/}
eval "unzip -o $nameZip -d tmp"

rm -rf $DOC_ROOT/*
eval "mv -f tmp/wordpress/* $DOC_ROOT"
eval "chown -R www-data:www-data $DOC_ROOT"

echo "Write the wp-config.php file"
cd $DOC_ROOT
cp wp-config-sample.php wp-config.php
sed -i 's/database_name_here/'$DB_NAME'/' wp-config.php
sed -i 's/username_here/'$DB_USER'/' wp-config.php
sed -i 's/password_here/'$DB_PASSWORD'/' wp-config.php
eval "chmod 777 -R $DOC_ROOT"

# export DB_NAME
# export DB_USER
# export DB_PASSWORD
