#!/bin/bash

# That kind of goes beyond a simple "start" but as the manager bootstrap is both an install and start it is better to place it here so configuration and relationship configuration can be done before.

echo "Bootstraping manager node"

sudo bash -c "export CLOUDIFY_USERNAME=$ADMIN_USERNAME && export CLOUDIFY_PASSWORD=$ADMIN_PASSWORD && export CLOUDIFY_SSL_TRUST_ALL=True && cfy init -r && cfy bootstrap -p /opt/cfy/cloudify-manager-blueprints/simple-manager-blueprint.yaml -i /opt/cfy/cloudify-manager-blueprints/inputs.yml"

echo "Manager node has been bootstraped"
echo "Done"
