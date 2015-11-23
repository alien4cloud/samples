#!/bin/bash -e
if [ "$CONTEXT_ROOT" == "/" ]; then
  CONTEXT_ROOT=""
fi

if [ ! -d $DOC_ROOT/$CONTEXT_ROOT ]; then
  eval "sudo mkdir -p $DOC_ROOT/$CONTEXT_ROOT"
fi

sudo rm -rf $DOC_ROOT/$CONTEXT_ROOT/*
sudo mv -f /opt/wordpress/wordpress/* $DOC_ROOT/$CONTEXT_ROOT
sudo chown -R www-data:www-data $DOC_ROOT/$CONTEXT_ROOT
sudo chmod 777 -R $DOC_ROOT/$CONTEXT_ROOT

echo "End of Wordpress install, restart apache2 to charge all modules"
sudo /etc/init.d/apache2 restart
