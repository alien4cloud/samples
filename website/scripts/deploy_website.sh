#!/bin/bash

if ! type "unzip" > /dev/null; then
  echo "Install unzip..."
  sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
  while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    echo "Waiting for other software managers to finish..."
    sleep $[ ( $RANDOM % 10 )  + 2 ]s
  done
  sudo rm -f /var/lib/dpkg/lock
  sudo apt-get install unzip || error_exit $? "Failed on: sudo apt-get install unzip"
fi

if [ "$WEBFILE_URL" ]; then
  echo "Deploy from URL..."
  eval "wget $WEBFILE_URL"
  nameZip=${WEBFILE_URL##*/}
  eval "unzip -o $nameZip -d tmp"
else
  echo "Deploy from artifact"
  unzip -o $website_zip -d tmp
fi

if [ ! -d $DOC_ROOT/$CONTEXT_PATH ]; then
  eval "sudo mkdir -p $DOC_ROOT/$CONTEXT_PATH"
fi

eval "sudo rm -rf $DOC_ROOT/$CONTEXT_PATH/*"
eval "sudo mv -f tmp/* $DOC_ROOT/$CONTEXT_PATH"
eval "sudo chown -R www-data:www-data $DOC_ROOT/$CONTEXT_PATH"

echo "End of website install, restart apache2 to update permission on $DOC_ROOT/$CONTEXT_PATH"
sudo /etc/init.d/apache2 restart
