#!/bin/bash -e

sudo yum -y install python-setuptools python-setuptools-devel
sudo easy_install pip

# Install Hostpool Service
if [ ! -d /opt/cloudify-hostpool-service ] ; then
  if [ ! -d ~/cloudify-hostpool-service-pkg ] ; then
    mkdir ~/cloudify-hostpool-service-pkg
    tar xvfz ${archive} -C ~/cloudify-hostpool-service-pkg
  fi
  sudo mkdir -p /root/.ssh
  ## override the exports.sh file
  EXPORTS_FILE=~/cloudify-hostpool-service-pkg/bin/base/exports.sh
  echo "" > $EXPORTS_FILE

  echo "export HOSTPOOL_HOMEDIR=$HOSTPOOL_HOMEDIR" >> $EXPORTS_FILE
  echo "export HOSTPOOL_USER=$HOSTPOOL_USER" >> $EXPORTS_FILE
  echo "export HOSTPOOL_GROUP=$HOSTPOOL_GROUP" >> $EXPORTS_FILE
  echo "export HOSTPOOL_HOMEDIR=$HOSTPOOL_HOMEDIR" >> $EXPORTS_FILE
  echo "export SVC_PORT=$SVC_PORT" >> $EXPORTS_FILE
  echo "export DATA_PATH=$DATA_PATH" >> $EXPORTS_FILE

  sudo ~/cloudify-hostpool-service-pkg/bin/install.sh
fi

echo ""
echo ""
echo "Hostpool installed."
