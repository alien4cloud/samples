#!/bin/bash 

# Loads env comming from the relationship
source ${HOME}/.${INSTANCE}_env.sh
if [ -z "$TARGET_IP" ] ; then
  echo "Couldn't find the variable \$TARGET_IP"
  exit 1
else
  ETCD_IP=${TARGET_IP}
fi

# Args
if [ -z "$FLANNEL_VERSION" ] ; then
  FLANNEL_VERSION=0.5.5
fi

if [ -z "$FLANNEL_IFACE" ] ; then
  FLANNEL_IFACE=eth0
fi

if [ -z "$FLANNEL_IPMASQ" ] ; then
  FLANNEL_IPMASQ=true
fi

# if [ -z "$ETCD_IP" ] ; then
#   ETCD_IP=$(hostname --ip-address)
# fi

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

# Stop docker service
sudo service docker stop

# Pull image
sudo docker -H unix:///var/run/docker-bootstrap.sock pull quay.io/coreos/flannel:${FLANNEL_VERSION}

# Run container
container_id=$(sudo docker -H unix:///var/run/docker-bootstrap.sock run -d --net=host --privileged -v /dev/net:/dev/net quay.io/coreos/flannel:${FLANNEL_VERSION} /opt/bin/flanneld --ip-masq=${FLANNEL_IPMASQ} --etcd-endpoints=http://${ETCD_IP}:4001 --iface=${FLANNEL_IFACE})


# Retrieve flannel configuration
flannel_output=$(execute_and_wait "sudo docker -H unix:///var/run/docker-bootstrap.sock exec $container_id cat /run/flannel/subnet.env")

# On error, stop the container then delete it before retry
# docker -H unix:///var/run/docker-bootstrap.sock stop $container_id
# docker -H unix:///var/run/docker-bootstrap.sock rm $container_id

# Edit docker configuration
sudo cp /etc/default/docker /etc/default/docker.default
cp /etc/default/docker /tmp/docker
for var in $flannel_output ; do
  echo $var | tee -a /tmp/docker
done
echo 'DOCKER_OPTS="--bip=${FLANNEL_SUBNET} --mtu=${FLANNEL_MTU}"' | tee -a /tmp/docker
sudo mv /tmp/docker /etc/default/docker

sudo service docker start

# Check flannel process
execute_and_wait "pgrep -f '/opt/bin/flanneld'"
execute_and_wait "pgrep -f \"docker-containerd-shim $container_id\""