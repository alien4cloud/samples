#!/bin/bash

# Loads env comming from the relationship
source ${HOME}/.${INSTANCE}_env.sh
if [ -z "$TARGET_IP" ] ; then
  echo "Couldn't find the variable \$TARGET_IP"
  exit 1
else
  MASTER_IP=${TARGET_IP}
fi

# Args
# if [ -z "$MASTER_IP" ] ; then
#   MASTER_IP=$(hostname --ip-address)
# fi

if [ -z "$FLANNEL_IFACE" ] ; then
  FLANNEL_IFACE=eth0
fi

# Remove node from master
LOCAL_IP=$(ifconfig $FLANNEL_IFACE | grep "inet addr" | sed 's/.*inet addr:\([0-9.]*\).*/\1/')
curl -X DELETE http://$MASTER_IP:8080/api/v1/nodes/$LOCAL_IP
