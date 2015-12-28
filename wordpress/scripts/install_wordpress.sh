#!/bin/sh
echo "Install wordpress from directory ${PWD}, download url is $WEBFILE_URL"
if ! type "unzip" > /dev/null; then
  echo "Install unzip..."

  NAME="unzip for wordpress"
  LOCK="/tmp/lockaptget"

  while true; do
    if mkdir "${LOCK}" &>/dev/null; then
      echo "$NAME take apt lock"
      break;
    fi
    echo "$NAME waiting apt lock to be released..."
    sleep 0.5
  done

  while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    echo "$NAME waiting for other software managers to finish..."
    sleep 0.5
  done

  sudo rm -f /var/lib/dpkg/lock
  sudo apt-get update || (sleep 15; sudo apt-get update || exit ${1})
  sudo apt-get -y install unzip || exit ${1}

  rm -rf "${LOCK}"
  echo "$NAME released apt lock"
fi

nameZip=${WEBFILE_URL##*/}
echo "Dowload last build of Wordpress from $WEBFILE_URL to /tmp/$nameZip"
if hash wget 2>/dev/null; then
  sudo wget $WEBFILE_URL -O /tmp/$nameZip
else
  sudo curl -Lo /tmp/$nameZip -O $WEBFILE_URL
fi

echo "Unzip wordpress from /tmp/$nameZip to /opt/wordpress"
sudo unzip -o /tmp/$nameZip -d /opt/wordpress
