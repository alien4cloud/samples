#!/bin/bash

INPUT_HDFS_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoInput/HDFS_URL)
INPUT_HDFS_PATH=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoInput/HDFS_PATH)
export INPUT_FILE_URL="${INPUT_HDFS_URL}${INPUT_HDFS_PATH}"

ES_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/Ecriture2Elasticsearch/ES_URL)
export ES_URL="${ES_URL}"

HDFS_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/TraitementConnect2Hdfs/HDFS_URL)
export HDFS_URL="${HDFS_URL}"

SPARK_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/TraitementConnect2Spark/SPARK_URL)
export SPARK_URL="${SPARK_URL}"
