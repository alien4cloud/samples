#!/bin/bash

mkdir -p /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/KafkaTopicConnectToBroker
echo "${KAFKA_IP}" > /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/KafkaTopicConnectToBroker/KAFKA_IP
echo "${KAFKA_PORT}" > /tmp/a4c/work/${SOURCE_NODE}/${SOURCE_INSTANCE}/KafkaTopicConnectToBroker/KAFKA_PORT
