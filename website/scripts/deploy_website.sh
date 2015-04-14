#!/bin/bash
if ! type "unzip" > /dev/null; then
  echo "Install unzip..."

  NAME="wordpress - unzip"
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
  sudo apt-get install unzip || exit ${1}

  rm -rf "${LOCK}"
  echo "$NAME released apt lock"
fi

if [ "$WEBFILE_URL" ]; then
  echo "Deploy from URL..."
  eval "wget $WEBFILE_URL"
  nameZip=${WEBFILE_URL##*/}
  eval "unzip -o $nameZip -d tmp"
else
  echo "Deploy from artifact"
  unzip -o $website_zip -d tmp
fi

if [ ! -d $DOC_ROOT/$CONTEXT_PATH ]; then
  eval "sudo mkdir -p $DOC_ROOT/$CONTEXT_PATH"
fi

eval "sudo rm -rf $DOC_ROOT/$CONTEXT_PATH/*"
eval "sudo mv -f tmp/* $DOC_ROOT/$CONTEXT_PATH"
eval "sudo chown -R www-data:www-data $DOC_ROOT/$CONTEXT_PATH"

echo "End of website install, restart apache2 to update permission on $DOC_ROOT/$CONTEXT_PATH"
sudo /etc/init.d/apache2 restart
