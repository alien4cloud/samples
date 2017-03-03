#!/bin/bash 

if [ -z "$LOCAL_IP" ] ; then
  LOCAL_IP=$(hostname --ip-address)
fi

if [ -z "$ETCD_VERSION" ] ; then
  ETCD_VERSION=2.2.1
fi


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


# Create etcd

echo "Running the etcd container"

sudo docker -H unix:///var/run/docker-bootstrap.sock pull gcr.io/google_containers/etcd-amd64:${ETCD_VERSION}

container_id=$(sudo docker -H unix:///var/run/docker-bootstrap.sock run -d --net=host gcr.io/google_containers/etcd-amd64:${ETCD_VERSION} /usr/local/bin/etcd --listen-client-urls=http://127.0.0.1:4001,http://${LOCAL_IP}:4001 --advertise-client-urls=http://${LOCAL_IP}:4001 --data-dir=/var/etcd/data)

execute_and_wait "pgrep -f '/usr/local/bin/etcd'"
execute_and_wait "sudo docker -H unix:///var/run/docker-bootstrap.sock exec $container_id etcdctl --version"

# Set value and Verify
max_retries=5
retries=0
sudo docker -H unix:///var/run/docker-bootstrap.sock exec $container_id etcdctl set /coreos.com/network/config '{ "Network": "18.1.0.0/16" }'
sudo docker -H unix:///var/run/docker-bootstrap.sock exec $container_id etcdctl get /coreos.com/network/config
output=$?
while [ "$output" != "0" -a $retries -lt $max_retries ] ; do  
  echo "Wait and retry ($retries/$max_retries)"
  sleep 1
  retries=$(($retries+1))
  sudo docker -H unix:///var/run/docker-bootstrap.sock exec $container_id etcdctl set /coreos.com/network/config '{ "Network": "18.1.0.0/16" }'
  sudo docker -H unix:///var/run/docker-bootstrap.sock exec $container_id etcdctl get /coreos.com/network/config
  output=$?
done

if [ $retries = $max_retries ] ; then 
  echo "Exit with error. Reached max retries ($max_retries)"
  exit 1
fi

#sudo docker stop $container_id
