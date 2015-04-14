#!/bin/bash
echo "Git install..."

NAME="Git"
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
sudo apt-get install -y -q git || exit ${1}

rm -rf "${LOCK}"
echo "$NAME released apt lock"

echo "Configure git (get from ENV git_user / git_email)"
sudo /usr/bin/git config --global user.name $GIT_USER
sudo /usr/bin/git config --global user.email $GIT_EMAIL
