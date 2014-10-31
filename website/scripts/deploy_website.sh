#!/bin/bash

if [ -z "${WEBFILE_CURL}" ]; then
  unzip $WEBFILE_ZIP -d $DOC_ROOT
else
  curl $WEBFILE_CURL
  nameZip=${URL##*/}
  unzip $nameZip -d $DOC_ROOT
fi
