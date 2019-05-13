#!/bin/bash

INPUT_HDFS_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoInput/HDFS_URL)
INPUT_HDFS_PATH=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoInput/HDFS_PATH)
export INPUT_FILE_URL="${INPUT_HDFS_URL}${INPUT_HDFS_PATH}"

OUTPUT_HDFS_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoOutput/HDFS_URL)
OUTPUT_HDFS_PATH=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoOutput/HDFS_PATH)
export OUTPUT_FILE_URL="${OUTPUT_HDFS_URL}${OUTPUT_HDFS_PATH}"

ERROR_HDFS_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoError/HDFS_URL)
ERROR_HDFS_PATH=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoError/HDFS_PATH)
export ERROR_FILE_URL="${ERROR_HDFS_URL}${ERROR_HDFS_PATH}"

HDFS_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/TraitementConnect2Hdfs/HDFS_URL)
export HDFS_URL="${HDFS_URL}"

SPARK_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/TraitementConnect2Spark/SPARK_URL)
export SPARK_URL="${SPARK_URL}"
