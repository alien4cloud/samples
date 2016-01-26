#!/bin/bash
# PLEASE don't add -e above since we want the grep to 'fail' if no match found
export ES_PORT=9300
# set the IP of an ElasticSearch in the alien configuration
grep "ELASTTICSEARCH-IP" /etc/alien4cloud/alien4cloud-config.yml
# $? will be 0 if the grep matches, 1 otherwise
if [ $? -eq 0 ]; then
  sudo sed -i -e "s/ELASTTICSEARCH-IP/$ES_IP\:$ES_PORT/g" /etc/alien4cloud/alien4cloud-config.yml
else
  sudo sed -i -e "s/hosts\: \(.*\)/hosts\: \1,$ES_IP\:$ES_PORT/g" /etc/alien4cloud/alien4cloud-config.yml
fi
