#!/bin/bash

if ! type "unzip" > /dev/null; then
  echo "Install unzip..."
  sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
  sudo apt-get install unzip || error_exit $? "Failed on: sudo apt-get install unzip"
fi

echo "Dowload and unzip the last build of Wordpress in $DOC_ROOT/$CONTEXT_PATH..."
eval "wget $WEBFILE_URL"

nameZip=${WEBFILE_URL##*/}
eval "unzip -o $nameZip -d tmp"

if [ ! -d $DOC_ROOT/$CONTEXT_PATH ]; then
  eval "mkdir -p $DOC_ROOT/$CONTEXT_PATH"
fi

eval "rm -rf $DOC_ROOT/$CONTEXT_PATH/*"
eval "mv -f tmp/wordpress/* $DOC_ROOT/$CONTEXT_PATH"
eval "chown -R www-data:www-data $DOC_ROOT/$CONTEXT_PATH"
eval "chmod 777 -R $DOC_ROOT/$CONTEXT_PATH"

echo "End of Wordpress install, restart apache2 to charge all modules"
sudo /etc/init.d/apache2 restart
