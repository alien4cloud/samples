#!/bin/bash -ex

# Install aws cli
if [ ! -f ~/.apt-get.updated ] ; then
    sudo apt-get -y update || (sleep 20; sudo apt-get update || exit ${1})
    date > ~/.apt-get.updated
  fi
  sudo apt-get -y install awscli || (sleep 20; sudo apt-get -y install awscli || exit ${1})

# Init aws credentials
if [ ! -d ~/.aws ]  ; then
  mkdir ~/.aws
fi

if [ ! -f ~/.aws/config ] ; then
  cat << EOF >> ~/.aws/config
[default]
region=
aws_access_key_id=
aws_secret_access_key=
EOF
fi
