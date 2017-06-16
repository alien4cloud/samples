#!/bin/bash

# That kind of goes beyond a simple "start" but as the manager bootstrap is both an install and start it is better to place it here so configuration and relationship configuration can be done before.

echo "Bootstraping manager node"

cd /opt/cfy/cloudify-manager-blueprints
sudo cfy bootstrap simple-manager-blueprint.yaml -i inputs.yml

echo "Setting ssl option"

# modify a file so we can access the manager via the webui
sudo -E /opt/manager/env/bin/python ${ssl_ui_conf_python_script}
sudo systemctl restart cloudify-stage

echo "Manager node has been bootstraped"

# Eventually configure cluster
if [ $MAX_INSTANCES -gt 1 ]; then
  echo "Cluster mode enabled, configuring cluster mode"
  sudo -E /opt/manager/env/bin/python ${cluster_python_script}
  sudo chown cfyuser:cfyuser /opt/mgmtworker/env/plugins
  echo "Cluster mode configured"
fi

# added to make BYON work well !!!!
sudo mkdir /etc/cloudify/.ssh
sudo chown cfyuser:cfyuser /etc/cloudify/.ssh

# try a connection on localhost and fail if not ok
connection_test_cmd="curl -fkL --connect-timeout 30 -u ${ADMIN_USERNAME}:${ADMIN_PASSWORD} --basic ${API_PROTOCOL}://localhost:${API_PORT}/version"
echo "Expect ${API_PROTOCOL}://localhost:${API_PORT} to be up"
eval ${connection_test_cmd}
if [ "$?" -ne "0" ]; then
  echo "Waiting for ${API_PROTOCOL}://localhost:${API_PORT} to be up"
  sleep 30
  eval ${connection_test_cmd}
  if [ "$?" -ne "0" ]; then
    echo "Connection check failed"
    exit 1
  fi
fi
echo "Completed."
