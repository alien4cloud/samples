#!/bin/bash

# That kind of goes beyond a simple "start" but as the manager bootstrap is both an install and start it is better to place it here so configuration and relationship configuration can be done before.

echo "Bootstraping manager node"

cd /opt/cfy/cloudify-manager-blueprints
sudo cfy bootstrap simple-manager-blueprint.yaml -i inputs.yml

echo "Setting ssl option"

# modify a file so we can access the manager via the webui
sudo -E /opt/manager/env/bin/python ${ssl_ui_conf_python_script}

echo "Manager node has been bootstraped"

# Eventually configure cluster
if [ $MAX_INSTANCES -gt 1 ]; then
  echo "Cluster mode enabled, configure cluster mode"
  sudo -E /opt/manager/env/bin/python ${cluster_python_script}
  echo "Cluster mode enabled, configure cluster mode"
fi

echo "Done"
