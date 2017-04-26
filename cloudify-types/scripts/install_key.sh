#!/bin/bash -e

echo "installing ssh key on the manager"

HOME_DIR=~
cp ${key_file} "$HOME_DIR/cfy_keys/"

echo "ssh key installed on the manager"
