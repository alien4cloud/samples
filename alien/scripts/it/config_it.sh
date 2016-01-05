#!/bin/bash -e

# set the IP of an ElasticSearch in the IT configuration
cd /opt/alien4cloud/src/alien4cloud-provider-int-test/src/test/resources
sudo bash -c "echo 'host: ${ES_IP}' > es.yml"
sudo bash -c "echo 'cluster: alien4cloud' >> es.yml"
