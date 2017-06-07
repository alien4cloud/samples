#!/bin/bash

echo "BEGIN install node.js"

echo "apt-get update"
sudo apt-get update

echo "installing nodejs version ${COMPONENT_VERSION}"

curl -sL https://deb.nodesource.com/setup_${COMPONENT_VERSION} | sudo bash -
sudo apt-get install -y nodejs

echo "ln -s /usr/bin/nodejs /usr/bin/node"
sudo ln -s /usr/bin/nodejs /usr/bin/node

echo "END install node.js"
