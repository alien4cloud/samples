#!/bin/bash

echo "BEGIN mongo install"

echo "add mongo key to source list"

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

echo "apt-get update"
sudo apt-get update -y

echo "apt-get install -y mongodb-org"
sudo apt-get install -y mongodb-org


COUNTER=0
mongostart=''
while [  $COUNTER -lt 30 ]; do
   let COUNTER=COUNTER+1
   echo "waiting for mongo to start: try $COUNTER /30"
   mongostart=$(sudo tail -1 /var/log/mongodb/mongod.log | grep "waiting for connections on port")
   if [[ ! -z $mongostart ]]
   then
       echo "END mongo service start"
       exit 0
   fi
   sleep 5
done

echo "ERROR: timeout fail to start mongo"
exit 1

echo "END mongo install"
