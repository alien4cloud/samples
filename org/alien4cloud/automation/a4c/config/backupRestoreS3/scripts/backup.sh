#!/bin/bash -ex
# for line in $(cat /home/ubuntu/.aws/config) ; do
#   if [ "$line" != "[default]" ] ; then
#   export $line
#   fi
# done


user=$(whoami)
A4C_CONFIG="/opt/alien4cloud/alien4cloud/config/alien4cloud-config.yml"

# Elasticsear IP adress
ES_IP=$(cat ${A4C_CONFIG} | grep "hosts: " | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])')


# Url to access ElasticSearch rest api.
ES_URL="${ES_IP}:9200"
echo "adresse ip d'elastic search $ES_IP"

# Backup target directories
ALIEN_BACKUP_DIR=/tmp/archives
BACKUP_NAME=${TAG_NAME}_a4c_`date '+%d_%m_%Y_%H_%M'`
ES_SNAPSHOT_NAME=${TAG_NAME}_es_`date '+%d_%m_%Y_%H_%M'`
ES_BACKUP_DIR=${TAG_NAME}_es_`date '+%d_%m_%Y_%H_%M'`

if [ -d $ALIEN_BACKUP_DIR ]; then
  echo "the directory $ALIEN_BACKUP_DIR already exists"
else
  mkdir -p $ALIEN_BACKUP_DIR
  sudo chown -R $user:$user $ALIEN_BACKUP_DIR
fi

# setup elastic search snapshot repository
curl -s -XPUT "${ES_IP}:9200/_snapshot/es_backup/" -d '{
  "type": "s3",
   "settings": {
     "access_key": "'$AWS_ACCESS_KEY'",
     "secret_key": "'$AWS_SECRET_KEY'",
     "bucket": "a4c-demo",
     "region": "'$REGION'",
     "base_path": "'$ES_BACKUP_DIR'",
     "compress": "true"
  }
}' >> /tmp/backup_log

# trigger elastic search data backup (asynchronous) "search indices in alien"
RESULT=`curl -s -XPUT "$ES_IP:9200/_snapshot/es_backup/$ES_SNAPSHOT_NAME?wait_for_completion=true" -d '{
  "indices": "csargitrepository,topology,alienaudit,group,plugin,toscaelement,serviceresource,pluginconfiguration,a4cdinstancereport,promotionrequest,paasdeploymentlog,csar,orchestrator,deploymenttopology,suggestion,applicationenvironment,metapropconfiguration,orchestratorconfiguration,locationresourcetemplate,imagedata,deployment,dashboardsnapshotinformations,deploymentmonitorevents,repository,applicationversion,location,deployedtopologies,user,application"
}'` >> /tmp/backup_log

SUCCESS=$(echo "$RESULT" | grep "\"shards\":{\"total\":29,\"failed\":0,\"successful\":29}")
echo "snapshot elasticsearch $RESULT"

if [ -z "$SUCCESS" ]; then
  echo "Failed to backup Elastic Search"
  echo $RESULT
  exit 1
else
  # Copy file system data
  # backup runtime files
  sudo cp -r ${DATA_DIR} $ALIEN_BACKUP_DIR/$BACKUP_NAME

  # Compress the runtime dir
  tar czf $ALIEN_BACKUP_DIR/${BACKUP_NAME}.tar.gz -C $ALIEN_BACKUP_DIR ./${BACKUP_NAME}

  echo $ALIEN_BACKUP_DIR/${BACKUP_NAME}.tar.gz
  sudo rm -rf $ALIEN_BACKUP_DIR/$BACKUP_NAME

  # copy the Buackup to S3 repository

  aws s3 cp --profile demo $ALIEN_BACKUP_DIR/${BACKUP_NAME}.tar.gz ${S3_URL}
  export ELASTICSEARCH_NAME=$ES_SNAPSHOT_NAME
  export ALIEN_ARCHIVE=${BACKUP_NAME}.tar.gz

  # delete the archive created in alien node
  sudo rm -rf $ALIEN_BACKUP_DIR/${BACKUP_NAME}.tar.gz
fi
