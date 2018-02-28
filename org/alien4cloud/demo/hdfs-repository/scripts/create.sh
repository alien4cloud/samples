#!/bin/bash

# FIXME: setup on manager
export PATH=$PATH:/opt/ext/hadoop/hadoop-2.9.0/bin
export PATH=$PATH:/opt/ext/spark/spark-2.2.1-bin-hadoop2.7/bin
export JAVA_HOME=/usr/java/jre1.8.0_45

echo "Creating folder ${HDFS_URL}/${HDFS_PATH}/${INSTANCE}"
hdfs dfs -Dfs.defaultFS=${HDFS_URL} -Ddfs.client.use.datanode.hostname=true -mkdir -p ${HDFS_PATH}/${INSTANCE}
if [ "$?" != "0" ]; then
  echo "Not able to create folder ${HDFS_URL}/${HDFS_PATH}/${INSTANCE}, something went wrong"
  exit 1
else
  echo "Folder ${HDFS_URL}/${HDFS_PATH}/${INSTANCE} created"
  hdfs dfs -Dfs.defaultFS=${HDFS_URL} -Ddfs.client.use.datanode.hostname=true -chmod -R 777 ${HDFS_PATH}/${INSTANCE}
fi

export HDFS_FOLDER_PATH="${HDFS_PATH}/${INSTANCE}"
export HDFS_FOLDER_URL="${HDFS_URL}"
