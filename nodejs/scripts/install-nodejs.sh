#!/bin/bash

echo "BEGIN install node.js"

echo "apt-get update"
sudo apt-get update

echo "apt-get install nodejs npm"
sudo apt-get install -y nodejs npm

sudo npm install -y npm -g

echo "ln -s /usr/bin/nodejs /usr/bin/node"
sudo ln -s /usr/bin/nodejs /usr/bin/node

echo "END install node.js"
