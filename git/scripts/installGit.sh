#!/bin/bash

echo "Git and install..."

sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
  echo "Waiting for other software managers to finish..."
  sleep 0.5
done
sudo rm -f /var/lib/dpkg/lock
sudo apt-get install -y -q git || error_exit $? "Failed on: sudo apt-get install -y -q git"

echo "Configure git (get from ENV git_user / git_email)"
sudo /usr/bin/git config --global user.name $GIT_USER
sudo /usr/bin/git config --global user.email $GIT_EMAIL
