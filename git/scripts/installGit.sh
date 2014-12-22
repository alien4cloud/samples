#!/bin/bash

echo "Git and install..."

sudo apt-get update || exit ${1}
while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  echo "Waiting for other software managers to finish..."
  sleep $[ ( $RANDOM % 10 )  + 2 ]s
done
sudo rm -f /var/lib/dpkg/lock
sudo apt-get install -y -q git || exit ${1}

echo "Configure git (get from ENV git_user / git_email)"
sudo /usr/bin/git config --global user.name $GIT_USER
sudo /usr/bin/git config --global user.email $GIT_EMAIL
