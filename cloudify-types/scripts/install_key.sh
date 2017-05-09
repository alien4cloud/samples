#!/bin/bash -xe

echo "installing ssh key on the manager"

HOME_DIR=~
cp ${key_file} "$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME"

export KEY_FILE_PATH="$HOME_DIR/cfy_keys/$SSH_KEY_FILENAME"

echo "ssh key installed on the manager"
