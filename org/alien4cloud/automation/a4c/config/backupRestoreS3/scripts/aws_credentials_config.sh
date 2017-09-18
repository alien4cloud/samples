#!/bin/bash -ex

# install s3 plugin for the backup/restore
cd /usr/share/elasticsearch
sudo bin/plugin install elasticsearch/elasticsearch-cloud-aws/2.7.1
sudo /etc/init.d/elasticsearch restart

# add a profile to the aws cli

if [ ! -f ~/.aws/config ] ; then
  vi ~/.aws/config
  cat << EOF >> ~/.aws/config
[profile demo]
region=${REGION}
aws_access_key_id=${AWS_ACCESS_KEY}
aws_secret_access_key=${AWS_SECRET_KEY}
EOF
else
  cat << EOF >> ~/.aws/config
[profile demo]
region=${REGION}
aws_access_key_id=${AWS_ACCESS_KEY}
aws_secret_access_key=${AWS_SECRET_KEY}
EOF
fi
