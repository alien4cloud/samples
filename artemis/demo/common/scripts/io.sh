#!/bin/bash

mkdir -p /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/SparkApp2HdfsRepo${REL_TYPE}
echo "${HDFS_URL}" > /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/SparkApp2HdfsRepo${REL_TYPE}/HDFS_URL
echo "${HDFS_PATH}" > /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/SparkApp2HdfsRepo${REL_TYPE}/HDFS_PATH
