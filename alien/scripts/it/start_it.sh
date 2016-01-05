#!/bin/bash -e

cd /opt/alien4cloud/src/alien4cloud-provider-int-test
sudo bash -c "export AWS_CLOUDIFY3_MANAGER_URL=${AWS_CLOUDIFY3_MANAGER_URL} && mvn -DdoTestRemote=true -Dit.test=${IT_TEST} clean verify > /var/log/alien4cloud/alien4cloud-it.out 2>&1 &" 2>&1 &
