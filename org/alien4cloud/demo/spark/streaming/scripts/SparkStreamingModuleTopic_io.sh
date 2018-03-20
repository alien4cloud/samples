#!/bin/bash

mkdir -p /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/SparkStreamingModuleTopic${REL_TYPE}
echo "${KAFKA_BROKER_ENDPOINT}" > /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/SparkStreamingModuleTopic${REL_TYPE}/KAFKA_BROKER_ENDPOINT
echo "${TOPIC_NAME}" > /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/SparkStreamingModuleTopic${REL_TYPE}/TOPIC_NAME
