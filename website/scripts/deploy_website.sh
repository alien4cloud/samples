#!/bin/bash

if [ "$WEBFILE_URL" ]; then
  echo "Deploy from URL"
  wget $WEBFILE_URL
  nameZip=${WEBFILE_URL##*/}
  unzip -o $nameZip -d tmp
  eval "mv -f tmp/* $DOC_ROOT"
else
  echo "Deploy from artifact"
  unzip -o $WEBFILE_ZIP -d tmp
  eval "mv -f tmp/* $DOC_ROOT"
fi
