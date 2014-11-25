#!/bin/bash

service="apache2"

if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
then
  /etc/init.d/$service restart
else
  /etc/init.d/$service start
fi
