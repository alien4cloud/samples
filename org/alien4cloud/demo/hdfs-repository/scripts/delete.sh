#!/bin/bash

# FIXME: setup on manager
export PATH=$PATH:/opt/ext/hadoop/hadoop-2.9.0/bin
export PATH=$PATH:/opt/ext/spark/spark-2.2.1-bin-hadoop2.7/bin
export JAVA_HOME=/usr/java/jre1.8.0_45

echo "Deleting folder ${INSTANCE} in ${HDFS_URL}/${HDFS_PATH}"
hdfs dfs -Dfs.defaultFS=${HDFS_URL} -Ddfs.client.use.datanode.hostname=true -chmod -R 777 ${HDFS_PATH}/${INSTANCE}
hdfs dfs -Dfs.defaultFS=${HDFS_URL} -Ddfs.client.use.datanode.hostname=true -rm -r -f ${HDFS_PATH}/${INSTANCE}
if [ "$?" != "0" ]; then
  echo "Not able to delete folder ${INSTANCE} at ${HDFS_URL}/${HDFS_PATH}, something went wrong"
  exit 1
else
  echo "Folder ${INSTANCE} at ${HDFS_URL}/${HDFS_PATH} deleted"
fi
