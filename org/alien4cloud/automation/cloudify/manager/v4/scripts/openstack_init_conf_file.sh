#!/bin/bash

# let's generate the input file from the parameters
echo "Generate openstack configuration input file."

HOME_DIR=~

cat << EOF > $HOME_DIR/cfy_config_openstack.yml
auth_url: '$KEYSTONE_URL'
username: '$USERNAME'
password: '$PASSWORD'
region: '$REGION'
tenant_name: '$TENANT_NAME'
agent_sh_user: '$AGENT_SH_USER'
resources:
  agents_security_group:
    name: '$AGENTS_SECURITY_GROUP_NAME'
  int_network:
    id: '$MANAGEMENT_NETWORK_ID'
    name: '$MANAGEMENT_NETWORK_NAME'
EOF

echo "Openstack configuration file has been generated"
