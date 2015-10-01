#!/bin/bash -e

echo "install PHP module for Mysql..."

NAME="PHP module for MySQL"
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
sudo apt-get -y -q install php5-mysql || exit ${1}

rm -rf "${LOCK}"
echo "$NAME released apt lock"

echo "restart apache2 to launch php5-mysql"
if (( $(ps -ef | grep -v grep | grep apache2 | wc -l) > 0 ))
  then
  sudo /etc/init.d/apache2 restart
else
  sudo /etc/init.d/apache2 start
fi
