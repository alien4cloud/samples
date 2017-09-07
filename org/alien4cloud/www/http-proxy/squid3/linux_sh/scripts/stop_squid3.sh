#!/bin/bash

if (( $(ps -ef | grep -v grep | grep -v $0 | grep squid3 | wc -l) > 0 ))
then
  sudo service squid3 stop
fi
