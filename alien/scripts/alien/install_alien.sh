#!/bin/bash -e

echo "Using apt-get. Installing Alien4Cloud on one of the following : Debian, Ubuntu, Mint"

# create user
sudo useradd alien4cloud

# create log folder
if [ ! -d /var/log/alien4cloud ]; then
  sudo mkdir /var/log/alien4cloud
fi

# create application folder and copie files
sudo wget --quiet -O alien.war ${APPLICATION_URL}
if [ ! -d /opt/alien4cloud ]; then
  sudo mkdir /opt/alien4cloud
fi
sudo cp alien.war /opt/alien4cloud/alien.war

# add configs
if [ ! -d /etc/alien4cloud ]; then
  sudo mkdir /etc/alien4cloud
fi
sudo cp -R -f $configs/* /etc/alien4cloud

# add the appropriate user
sudo chown -R alien4cloud:alien4cloud /var/log/alien4cloud
sudo chown -R alien4cloud:alien4cloud /opt/alien4cloud
sudo chown -R alien4cloud:alien4cloud /etc/alien4cloud

# add init script and start service

sudo bash -c "sed -e 's/\\\${APP_ARGS}/${APP_ARGS}/' $bin/alien.sh > /etc/init.d/alien"
sudo chmod +x /etc/init.d/alien

sudo update-rc.d alien defaults 95 10
