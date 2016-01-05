#!/bin/bash -e

# set the IP of an ElasticSearch in the alien configuration
sudo sed -i -e "s/ELASTTICSEARCH-IP/$ES_IP/g" /etc/alien4cloud/alien4cloud-config.yml
