#!/bin/bash

echo "Git and install..."
sudo apt-get update || error_exit $? "Failed on: sudo apt-get update"
sudo apt-get install -y -q git || error_exit $? "Failed on: sudo apt-get install -y -q git"

echo "Configure git (get from ENV git_user / git_email)"
/usr/bin/git config --global user.name $GIT_USER
/usr/bin/git config --global user.email $GIT_EMAIL
