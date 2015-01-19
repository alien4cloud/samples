#!/bin/sh
echo "Install wordpress from directory ${PWD}, download url is $WEBFILE_URL"
if ! type "unzip" > /dev/null; then
  echo "Install unzip..."
  sudo apt-get update || exit ${1}
  while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    echo "Waiting for other software managers to finish..."
    sleep 2
  done
  sudo apt-get install unzip || exit ${1}
fi

nameZip=${WEBFILE_URL##*/}
echo "Dowload last build of Wordpress from $WEBFILE_URL to /tmp/$nameZip"
wget $WEBFILE_URL -O /tmp/$nameZip

echo "Unzip wordpress from /tmp/$nameZip to /opt/wordpress"
sudo unzip -o /tmp/$nameZip -d /opt/wordpress