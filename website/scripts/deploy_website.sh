#!/bin/bash

if ! type "unzip" > /dev/null; then
  echo "Install unzip..."
  sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
  sudo apt-get install unzip || error_exit $? "Failed on: sudo apt-get install unzip"
fi

if [ "$WEBFILE_URL" ]; then
  echo "Deploy from URL..."
  eval "wget $WEBFILE_URL"
  nameZip=${WEBFILE_URL##*/}
  eval "unzip -o $nameZip -d tmp"
else
  echo "Deploy from artifact"
  unzip -o $WEBFILE_ZIP -d tmp
fi

if [ ! -d $DOC_ROOT/$CONTEXT_PATH ]; then
  eval "mkdir -p $DOC_ROOT/$CONTEXT_PATH"
fi

eval "rm -rf $DOC_ROOT/$CONTEXT_PATH/*"
eval "mv -f tmp/* $DOC_ROOT/$CONTEXT_PATH"
eval "chown -R www-data:www-data $DOC_ROOT/$CONTEXT_PATH"

echo "End of website install, restart apache2 to update permission on $DOC_ROOT/$CONTEXT_PATH"
sudo /etc/init.d/apache2 restart
