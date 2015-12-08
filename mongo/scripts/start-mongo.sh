#!/bin/bash

echo "BEGIN mongo start"

echo "service mongo start"

sudo service mongod start

echo "END service mongo stop"


 sudo echo "line use to check if mongo is restarting, do not delete it" | sudo tee /var/log/mongodb/mongod.log

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

