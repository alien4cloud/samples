#!/bin/bash

INPUT_HDFS_URL=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkStreamingModuleHdfsRepoInput/HDFS_URL)
INPUT_HDFS_PATH=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkStreamingModuleHdfsRepoInput/HDFS_PATH)
export INPUT_REPOSITORY_URL="${INPUT_HDFS_URL}${INPUT_HDFS_PATH}"

KAFKA_BROKER_ENDPOINT=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkStreamingModuleTopicOutput/KAFKA_BROKER_ENDPOINT)
export OUTPUT_KAFKA_BROKER_ENDPOINT="${KAFKA_BROKER_ENDPOINT}"

TOPIC_NAME=$(</tmp/a4c/work/${NODE}/${INSTANCE}/SparkStreamingModuleTopicOutput/TOPIC_NAME)
export OUTPUT_TOPIC_NAME="${TOPIC_NAME}"
