#!/bin/bash -e
source $commons/commons.sh

require_envs "MOUNT_POINT"

## unmount the samba share
sudo umount $MOUNT_POINT
