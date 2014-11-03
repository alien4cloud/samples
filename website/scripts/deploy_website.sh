#!/bin/bash

sudo apt-get update
sudo apt-get install unzip

if [ "$WEBFILE_URL" ]; then
  echo "Deploy from URL..."
  eval "wget $WEBFILE_URL"
  nameZip=${WEBFILE_URL##*/}
  eval "unzip -o $nameZip -d tmp"
else
  echo "Deploy from artifact"
  unzip -o $WEBFILE_ZIP -d tmp
fi
eval "mv -f tmp/* $DOC_ROOT"
eval "chown -R www-data:www-data $DOC_ROOT"
