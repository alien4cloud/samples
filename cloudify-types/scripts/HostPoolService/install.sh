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
  sudo ~/cloudify-hostpool-service-pkg/bin/install_hostpool.sh
fi

echo ""
echo ""
echo "Hostpool installed."
echo "   curl http://localhost:8080/hosts"
curl http://localhost:8080/hosts