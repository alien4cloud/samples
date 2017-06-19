#!/bin/bash

echo "Installing ssh key on the manager"

CFYUSER_HOMEDIR=/home/cfyuser
SSH_KEY_FILE_PATH=$CFYUSER_HOMEDIR/$SSH_KEY_FILENAME

if [ ! -d "$CFYUSER_HOMEDIR" ] ; then
  echo "Create /home/cfyuser"
  sudo mkdir $CFYUSER_HOMEDIR
  sudo chmod 700 $CFYUSER_HOMEDIR
  sudo chown -R cfyuser:cfyuser $CFYUSER_HOMEDIR
fi

echo "Copy ssh keyfile from $key_file into $SSH_KEY_FILE_PATH"
sudo cp ${key_file} "$SSH_KEY_FILE_PATH"
sudo chmod 400 "$SSH_KEY_FILE_PATH"
sudo chown -R cfyuser:cfyuser "$SSH_KEY_FILE_PATH"

export KEY_FILE_PATH="$SSH_KEY_FILE_PATH"

echo "ssh key installed on the manager"
