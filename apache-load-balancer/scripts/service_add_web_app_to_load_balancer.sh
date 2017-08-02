#!/bin/bash -e

export ADD_SCRIPT="${script_directory}/add_web_app_to_load_balancer.sh"

echo "Execute load balancer add script $ADD_SCRIPT on remote host: ssh -i ${ssh_key} ${USER}@${A4C_EXECUTION_HOST}"

chmod 0400 ${ssh_key}

# Just execute the add_web_app_to_load_balancer script on the target machine.
ssh -o StrictHostKeyChecking=no -i ${ssh_key} ${USER}@${A4C_EXECUTION_HOST} PROTOCOL=$PROTOCOL IP=$IP PORT=$PORT URL_PATH=$URL_PATH 'bash -s' < ${ADD_SCRIPT}
