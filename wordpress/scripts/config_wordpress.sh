#!/bin/bash

if [ "$CONTEXT_PATH" == "/" ]; then
  CONTEXT_PATH=""
fi

if ! type "unzip" > /dev/null; then
  echo "Install unzip..."
  sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
  while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    echo "Waiting for other software managers to finish..."
    sleep $[ ( $RANDOM % 10 )  + 2 ]s
  done
  sudo apt-get install unzip || error_exit $? "Failed on: sudo apt-get install unzip"
fi

echo "Dowload and unzip the last build of Wordpress in $DOC_ROOT/$CONTEXT_PATH..."
eval "wget $WEBFILE_URL"

nameZip=${WEBFILE_URL##*/}
eval "unzip -o $nameZip -d tmp"

if [ ! -d $DOC_ROOT/$CONTEXT_PATH ]; then
  eval "sudo mkdir -p $DOC_ROOT/$CONTEXT_PATH"
fi

eval "sudo rm -rf $DOC_ROOT/$CONTEXT_PATH/*"
eval "sudo mv -f tmp/wordpress/* $DOC_ROOT/$CONTEXT_PATH"
eval "sudo chown -R www-data:www-data $DOC_ROOT/$CONTEXT_PATH"
eval "sudo chmod 777 -R $DOC_ROOT/$CONTEXT_PATH"

echo "End of Wordpress install, restart apache2 to charge all modules"
sudo /etc/init.d/apache2 restart
