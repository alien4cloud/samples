#!/bin/bash


echo "BEGIN nodecellar stop-app.sh"

nodecellar_pid=$(cat ~/nodecellar/nodecellarpid.txt)

echo "kill nodecellar process"
sudo kill -9 $nodecellar_pid

echo "END nodecellar stop-app.sh"
