#!/bin/bash

mkdir -p /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/SparkStreamingModuleHdfsRepo${REL_TYPE}
echo "${HDFS_URL}" > /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/SparkStreamingModuleHdfsRepo${REL_TYPE}/HDFS_URL
echo "${HDFS_PATH}" > /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/SparkStreamingModuleHdfsRepo${REL_TYPE}/HDFS_PATH
