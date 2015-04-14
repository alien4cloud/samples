#!/bin/bash

echo "Debian based MYSQL install 5..."

NAME="MySQL"
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
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server-5.5 pwgen || exit ${1}

rm -rf "${LOCK}"
echo "$NAME released apt lock"

sudo /etc/init.d/mysql stop
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf /var/lib/mysql/*
echo "MySQL Installation complete."
