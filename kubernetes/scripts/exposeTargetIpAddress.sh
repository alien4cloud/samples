#!/bin/bash 

echo "export TARGET_IP=${TARGET_IP}" | tee ${HOME}/.${SOURCE_INSTANCE}_env.sh
export EXPORTED_TARGET_IP=${TARGET_IP}
