#!/bin/bash

# That kind of goes beyond a simple "start" but as the manager bootstrap is both an install and start it is better to place it here so configuration and relationship configuration can be done before.

echo "Bootstraping manager node"

sudo bash -c "export CLOUDIFY_USERNAME=$ADMIN_USERNAME && export CLOUDIFY_PASSWORD=$ADMIN_PASSWORD && export CLOUDIFY_SSL_TRUST_ALL=True && cfy init -r && cfy bootstrap -p /opt/cfy/cloudify-manager-blueprints/simple-manager-blueprint.yaml -i /opt/cfy/cloudify-manager-blueprints/inputs.yml"

echo "Manager node has been bootstraped"
echo "Done"

# try a connection on locahost and fail if not ok
curl -fkL --connect-timeout 30 http://localhost/version
if [ "$?" -ne "0" ]; then
  echo "waiting for locahost server to be up"
  sleep 30
fi
curl -fkL --connect-timeout 30 http://localhost/version
exit $?