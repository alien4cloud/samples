#!/bin/bash

OUTPUT_HDFS_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkStreamingModuleHdfsRepoOutput/HDFS_URL)
OUTPUT_HDFS_PATH=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkStreamingModuleHdfsRepoOutput/HDFS_PATH)
export OUTPUT_REPOSITORY_URL="${OUTPUT_HDFS_URL}${OUTPUT_HDFS_PATH}"

KAFKA_BROKER_ENDPOINT=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkStreamingModuleTopicInput/KAFKA_BROKER_ENDPOINT)
export INPUT_KAFKA_BROKER_ENDPOINT="${KAFKA_BROKER_ENDPOINT}"

TOPIC_NAME=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkStreamingModuleTopicInput/TOPIC_NAME)
export INPUT_TOPIC_NAME="${TOPIC_NAME}"
