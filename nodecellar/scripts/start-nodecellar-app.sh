#!/bin/bash


echo "node ~/nodecellar/nodecellar-master/server.js 2>&1 >/var/log/nodecellar.log &" 

source ~/nodecellar_env.sh

cd ~/nodecellar/

sudo -E node ~/nodecellar/nodecellar-master/server.js > ~/nodecellar/nodecellar.log 2>&1  &  

PID=$!

sudo echo "$PID" > ~/nodecellar/nodecellarpid.txt

echo "processus id :${PID}"

