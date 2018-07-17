#!/bin/bash

mkdir -p /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/KafkaTopicConnectToZookeeper
echo "${ZOOKEEPER_IP}" > /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/KafkaTopicConnectToZookeeper/ZOOKEEPER_IP
echo "${ZOOKEEPER_PORT}" > /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/KafkaTopicConnectToZookeeper/ZOOKEEPER_PORT
