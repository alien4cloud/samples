#!/bin/bash

# Loads env comming from the relationship
source ${HOME}/.${INSTANCE}_env.sh
if [ -z "$TARGET_IP" ] ; then
  echo "Couldn't find the variable \$TARGET_IP"
  exit 1
else
  MASTER_IP=${TARGET_IP}
fi

#Args
if [ -z "$K8S_VERSION" ] ; then
  K8S_VERSION=1.2.1
fi

# if [ -z "$MASTER_IP" ] ; then
#   MASTER_IP=$(hostname --ip-address)
# fi

if [ -z "$DNS_DOMAIN" ] ; then
  DNS_DOMAIN=cluster.local
fi

if [ -z "$FLANNEL_IFACE" ] ; then
  FLANNEL_IFACE=eth0
fi

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

sudo docker run --volume=/:/rootfs:ro --volume=/sys:/sys:ro --volume=/dev:/dev --volume=/var/lib/docker/:/var/lib/docker:rw --volume=/var/lib/kubelet/:/var/lib/kubelet:rw --volume=/var/run:/var/run:rw --net=host --privileged=true --pid=host -d gcr.io/google_containers/hyperkube-amd64:v${K8S_VERSION} /hyperkube kubelet --allow-privileged=true --api-servers=http://${MASTER_IP}:8080 --v=2 --address=0.0.0.0 --enable-server --containerized --hostname-override=${LOCAL_IP} --cluster-dns=18.1.0.1 --cluster-domain=$DNS_DOMAIN

# Run Proxy
sudo docker run -d --net=host --privileged gcr.io/google_containers/hyperkube-amd64:v${K8S_VERSION} /hyperkube proxy --master=http://${MASTER_IP}:8080 --v=2
