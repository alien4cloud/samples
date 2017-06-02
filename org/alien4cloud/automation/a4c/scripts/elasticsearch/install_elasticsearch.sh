#!/bin/bash -e
source $commons/commons.sh


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# OS configuration
sudo bash -c "echo 'vm.overcommit_memory=0' >> /etc/sysctl.conf"
sudo sysctl -p

openLimit=65535
sudo bash -c "echo 'elasticsearch         hard    nofile      $openLimit
elasticsearch         soft    nofile      $openLimit
' >> /etc/security/limits.conf"

# Download the application and install elasticsearch
download "ElasticSearch" "${APPLICATION_URL}" "elasticsearch.deb"

while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; 
do
	echo "$NAME waiting for other software managers to finish..."
  sleep 2
done
sudo dpkg -i elasticsearch*.deb

# Update configuration
sudo bash -c "cat $configs/elasticsearch.yml > /etc/elasticsearch/elasticsearch.yml"
sudo bash -c "cat $configs/logging.yml > /etc/elasticsearch/logging.yml"

# change defaults
sudo bash -c "echo 'ES_USE_GC_LOGGING=y' >> /etc/default/elasticsearch"
sudo bash -c "echo 'export ES_USE_GC_LOGGING' >> /etc/default/elasticsearch"
sudo bash -c "echo 'ES_JAVA_OPTS=-XX:+PrintGCDateStamps' >> /etc/default/elasticsearch"
sudo bash -c "echo 'ES_HEAP_SIZE=1g' >> /etc/default/elasticsearch"

# Configure init script and start elasticsearch
sudo update-rc.d elasticsearch defaults 95 10
