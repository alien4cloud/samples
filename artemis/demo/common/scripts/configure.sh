#!/bin/bash

INPUT_HDFS_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoInput/HDFS_URL)

if [ -z "$INPUT_HDFS_URL" ]; then
  export INPUT_FILE_URL="${DEFAULT_INPUT_FILE_URL}"
else
  INPUT_HDFS_PATH=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoInput/HDFS_PATH)
  TARGET_INSTANCE=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkAppDependency/TARGET_INSTANCE)
  export INPUT_FILE_URL="${INPUT_HDFS_URL}${INPUT_HDFS_PATH}/${TARGET_INSTANCE}"
fi

OUTPUT_HDFS_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoOutput/HDFS_URL)
OUTPUT_HDFS_PATH=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkApp2HdfsRepoOutput/HDFS_PATH)

export OUTPUT_FILE_URL="${OUTPUT_HDFS_URL}${OUTPUT_HDFS_PATH}/${INSTANCE}"
