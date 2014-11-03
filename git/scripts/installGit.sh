#!/bin/bash

echo "Git and install..."
sudo apt-get update && apt-get -yq install git

# Configure git (get from ENV git_user / git_email)
echo "Git and install..."
/usr/bin/git config --global user.name $GIT_USER
/usr/bin/git config --global user.email $GIT_EMAIL
