#!/bin/bash -e
source $commons/commons.sh

require_envs "MOUNT_POINT SAMBA_SERVER_IP SHARE_NAME"

## create the mounted point
sudo mkdir -p $MOUNT_POINT
sudo chmod 777 $MOUNT_POINT
sudo mount -t cifs //$SAMBA_SERVER_IP/$SHARE_NAME $MOUNT_POINT -o rw,sec=ntlm,guest
