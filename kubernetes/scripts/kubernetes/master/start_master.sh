#!/bin/bash

#Args
if [ -z "$K8S_VERSION" ] ; then
  K8S_VERSION=1.2.1
fi

if [ -z "$MASTER_IP" ] ; then
  MASTER_IP=$(hostname --ip-address)
fi

if [ -z "$DNS_DOMAIN" ] ; then
  DNS_DOMAIN=cluster.local
fi

if [ -z "$FLANNEL_IFACE" ] ; then
  FLANNEL_IFACE=eth0
fi


# Functions
function execute_and_wait {
  command=$1
  max_retries=6
  retries=0
  cmd_output=$(echo $command | sh)
  cmd_code=$?
  while [ "$cmd_code" != "0" -a $retries -lt $max_retries ] ; do
    echo "Executing $command. Wait and retry ($retries/$max_retries)"
    sleep 10
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

# Remove docker bridge
sudo service docker stop
sudo /sbin/ifconfig docker0 down
#sudo apt-get install -y bridge-utils
#sudo brctl delbr docker0
sudo ip link del docker0
sudo ifconfig
sudo service docker start

# Pull Hyperkube image
sudo docker pull gcr.io/google_containers/hyperkube-amd64:v${K8S_VERSION}

# Run Hyperkube
#LOCAL_IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
LOCAL_IP=$(ifconfig $FLANNEL_IFACE | grep "inet addr" | sed 's/.*inet addr:\([0-9.]*\).*/\1/')

sudo docker run --volume=/:/rootfs:ro --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:rw --volume=/var/lib/kubelet/:/var/lib/kubelet:rw --volume=/var/run:/var/run:rw --net=host --privileged=true --pid=host -d gcr.io/google_containers/hyperkube-amd64:v${K8S_VERSION} /hyperkube kubelet --allow-privileged=true --api-servers=http://localhost:8080 --v=2 --address=0.0.0.0 --enable-server --hostname-override=127.0.0.1 --config=/etc/kubernetes/manifests-multi --containerized --cluster-dns=18.1.0.1 --cluster-domain=$DNS_DOMAIN

execute_and_wait "curl http://localhost:8080/version"
execute_and_wait "curl http://localhost:8080/api/v1/nodes/127.0.0.1 | grep KubeletReady"