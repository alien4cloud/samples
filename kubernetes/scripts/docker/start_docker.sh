#!/bin/bash 

set -e

# Functions
function execute_and_wait {
  command=$1
  max_retries=5
  retries=0
  cmd_output=$(echo $command | sh)
  cmd_code=$?
  while [ "$cmd_code" != "0" -a $retries -lt $max_retries ] ; do
    echo "Executing $command. Wait and retry ($retries/$max_retries)"
    sleep 5
    retries=$(($retries+1))
    cmd_output=$(echo $command | sh)
    cmd_code=$?
  done

  if [ $retries = $max_retries ] ; then
    echo "Exit with error while executing $command. Reached max retries (=$max_retries)"
    exit 1
  fi
  echo $cmd_output
}

sudo sh -c 'docker daemon -H unix:///var/run/docker-bootstrap.sock -p /var/run/docker-bootstrap.pid --iptables=false --ip-masq=false --bridge=none --graph=/var/lib/docker-bootstrap 2> /var/log/docker-bootstrap.log 1> /dev/null &'
execute_and_wait "sudo pgrep -f 'docker daemon -H unix:///var/run/docker-bootstrap.sock'"