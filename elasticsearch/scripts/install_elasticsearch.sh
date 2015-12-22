#!/bin/bash -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# OS configuration
sudo bash -c "echo 'vm.overcommit_memory=0' >> /etc/sysctl.conf"
sudo sysctl -p

openLimit=65535
sudo bash -c "echo 'elasticsearch         hard    nofile      $openLimit
elasticsearch         soft    nofile      $openLimit
' >> /etc/security/limits.conf"

# Download the application and install elasticsearch
sudo wget --quiet ${APPLICATION_URL}
sudo dpkg -i elasticsearch*.deb

# Update configuration
sudo bash -c "cat $configs/elasticsearch.yml > /etc/elasticsearch/elasticsearch.yml"
sudo bash -c "cat $configs/logging.yml > /etc/elasticsearch/logging.yml"

# Configure init script and start elasticsearch
sudo update-rc.d elasticsearch defaults 95 10
sudo /etc/init.d/elasticsearch start
