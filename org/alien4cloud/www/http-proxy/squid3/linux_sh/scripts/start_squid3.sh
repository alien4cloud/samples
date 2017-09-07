#!/bin/bash -e

service_name="squid3"

if (( $(ps -ef | grep -v grep | grep -v $0 | grep $service_name | wc -l) > 0 ))
then
  sudo service $service_name restart
else
  sudo service $service_name start
fi
