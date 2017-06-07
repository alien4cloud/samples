#!/bin/bash -e
source $commons/commons.sh

install_dependencies "unzip"
require_bin "jar"
require_envs "DATA_DIR ALIEN_VERSION"

# create user
sudo useradd alien4cloud

# create log folder
echo "Make log dir"
if [ ! -d /var/log/alien4cloud ]; then
  sudo mkdir -p /var/log/alien4cloud
fi

echo "Make etc dir"
if [ ! -d /etc/alien4cloud ]; then
  sudo mkdir -p /etc/alien4cloud
fi

echo "Make etc env dir"
if [ ! -d /etc/alien4cloud/env ]; then
  sudo mkdir -p /etc/alien4cloud/env
fi

echo "Make tmp dir"
if [ ! -d /tmp/alien4cloud ]; then
	sudo mkdir -p /tmp/alien4cloud
fi

# create application folder
echo "Make opt dir"
if [ ! -d /opt/alien4cloud ]; then
  sudo mkdir -p /opt/alien4cloud
fi

# create data folder
echo "Make data dir $DATA_DIR"
if [ ! -d $DATA_DIR ]; then
  sudo mkdir -p $DATA_DIR
fi

# download files
#download "Alien4Cloud" "${APPLICATION_URL}" /tmp/alien4cloud/alien4cloud-premium-dist.tar.gz
sudo tar -xzf $alien_dist -C /opt/alien4cloud
# we want premium version to have the same dir name
if [ -d /opt/alien4cloud/alien4cloud-premium ]; then
	sudo mv -f /opt/alien4cloud/alien4cloud-premium /opt/alien4cloud/alien4cloud
fi

# add config
sudo rm -rf /tmp/alien4cloud

# add the appropriate user
echo "Change folder ownership"
sudo chown -R alien4cloud:alien4cloud /opt/alien4cloud

# can be removed as soon as $JAVA_EXT_OPTIONS is added in JAVA options in dist
# (but can be necessary if a version before 1.4.0-RC3 is used)
# sudo cp -f $config/alien4cloud.sh /opt/alien4cloud/alien4cloud/
# sudo sed -i -e "s/%ALIEN_VERSION%/${ALIEN_VERSION}/g" /opt/alien4cloud/alien4cloud/alien4cloud.sh
# sudo chmod +x /opt/alien4cloud/alien4cloud/alien4cloud.sh
# sudo cp -f $config/alien4cloud-ssl.sh /opt/alien4cloud/alien4cloud/
# sudo sed -i -e "s/%ALIEN_VERSION%/${ALIEN_VERSION}/g" /opt/alien4cloud/alien4cloud/alien4cloud-ssl.sh
# sudo chmod +x /opt/alien4cloud/alien4cloud/alien4cloud-ssl.sh
