#!/bin/bash

# FIXME: setup on manager
export PATH=$PATH:/opt/ext/hadoop/hadoop-2.9.0/bin
export PATH=$PATH:/opt/ext/spark/spark-2.2.1-bin-hadoop2.7/bin
export JAVA_HOME=/usr/java/jre1.8.0_45

remove_file() {
  echo "Deleting remote file at ${HDFS_URL}/data/$INSTANCE.jar"
  hdfs dfs -Dfs.defaultFS=${HDFS_URL} -Ddfs.client.use.datanode.hostname=true -rm /data/$INSTANCE.jar
}

remove_file
