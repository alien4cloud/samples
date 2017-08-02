#!/bin/bash -e

export REMOVE_SCRIPT="${script_directory}/remove_web_app_from_load_balancer.sh"

echo "Execute load balancer add script $REMOVE_SCRIPT on remote host: ssh -i ${ssh_key} ${USER}@${A4C_EXECUTION_HOST}"

chmod 600 ${ssh_key}

# Just execute the add_web_app_to_load_balancer script on the target machine.
ssh -o StrictHostKeyChecking=no -i ${ssh_key} ${USER}@${A4C_EXECUTION_HOST} PROTOCOL=$PROTOCOL IP=$IP PORT=$PORT URL_PATH=$URL_PATH 'bash -s' < ${REMOVE_SCRIPT}
