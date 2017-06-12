#!/bin/bash

# That kind of goes beyond a simple "start" but as the manager bootstrap is both an install and start it is better to place it here so configuration and relationship configuration can be done before.

echo "Bootstraping manager node"

sudo bash -c "export CLOUDIFY_USERNAME=$ADMIN_USERNAME && export CLOUDIFY_PASSWORD=$ADMIN_PASSWORD && export CLOUDIFY_SSL_TRUST_ALL=True && cfy init -r && cfy bootstrap -p /opt/cfy/cloudify-manager-blueprints/simple-manager-blueprint.yaml -i /opt/cfy/cloudify-manager-blueprints/inputs.yml"

echo "Manager node has been bootstraped"
echo "Done"

# try a connection on localhost and fail if not ok
connection_test_cmd="curl -fkL --connect-timeout 30 -u ${ADMIN_USERNAME}:${ADMIN_PASSWORD} --basic ${API_PROTOCOL}://localhost:${API_PORT}/version"
echo "Expect ${API_PROTOCOL}://localhost:${API_PORT} to be up"
eval ${connection_test_cmd}
if [ "$?" -ne "0" ]; then
  echo "Waiting for ${API_PROTOCOL}://localhost:${API_PORT} to be up"
  sleep 30
  eval ${connection_test_cmd}
  if [ "$?" -ne "0" ]; then
    echo "Connection check failed return $?"
    exit $?
  fi
fi
echo "Completed."
