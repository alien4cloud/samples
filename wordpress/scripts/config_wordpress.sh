#!/bin/bash
if [ "$CONTEXT_PATH" == "/" ]; then
  CONTEXT_PATH=""
fi

if [ ! -d $DOC_ROOT/$CONTEXT_PATH ]; then
  eval "sudo mkdir -p $DOC_ROOT/$CONTEXT_PATH"
fi

sudo rm -rf $DOC_ROOT/$CONTEXT_PATH/*
sudo mv -f /opt/wordpress/wordpress/* $DOC_ROOT/$CONTEXT_PATH
sudo chown -R www-data:www-data $DOC_ROOT/$CONTEXT_PATH
sudo chmod 777 -R $DOC_ROOT/$CONTEXT_PATH

echo "End of Wordpress install, restart apache2 to charge all modules"
sudo /etc/init.d/apache2 restart
