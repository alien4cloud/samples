#!/bin/bash -e

if [ -z ${ES_INIT_FILE} ] ; then
  echo " the elasticsearch init file is null "
  exit 0
fi

# script to restore elasticsearch
A4C_CONFIG="/opt/alien4cloud/alien4cloud/config/alien4cloud-config.yml"

# Elasticsear IP adress
ES_IP=$(cat ${A4C_CONFIG} | grep "hosts: " | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])')

# Initiate ES
ES_SNAPSHOT_DIR=${ES_INIT_FILE}
ES_SNAPSHOT_NAME=${ES_INIT_FILE}

# setup elastic search snapshot repository
echo "initiate snapshot repo"

curl -s -XPUT "$ES_IP:9200/_snapshot/es_backup/" -d '{
     "type": "s3",
       "settings": {
         "access_key": "'$AWS_ACCESS_KEY'",
         "secret_key": "'$AWS_SECRET_KEY'",
         "bucket": "a4c-demo",
         "region": "'$REGION'",
         "base_path": "'$ES_SNAPSHOT_DIR'"
  }
}' > /dev/null

# close indexes before restore operation
echo "close all indices"
curl -s -XPOST "$ES_IP:9200/_all/_close"

# trigger elastic search data restore
echo "restore snapshot"
curl -s -XPOST "$ES_IP:9200/_snapshot/es_backup/$ES_SNAPSHOT_NAME/_restore" > /dev/null

# init alien
ALIEN_DIR="/opt/alien4cloud/alien4cloud-premium"


mkdir -p /home/ubuntu/archives
# Get the archive file from S3 repository
echo "Download archive file from S3"
aws s3 cp --profile demo ${S3_URL}/${ALIEN_INIT_FILE}.tar.gz /tmp

# Extract Archive
echo "extract snapshot"
tar xf /tmp/${ALIEN_INIT_FILE}.tar.gz -C /home/ubuntu/archives

# Copy file system data
echo "copy runtime"
mkdir -p ${DATA_DIR}
sudo cp -Rf /tmp/${ALIEN_INIT_FILE}/* ${DATA_DIR}
curl -s -XPOST "$ES_IP:9200/_all/_open" > /dev/null
