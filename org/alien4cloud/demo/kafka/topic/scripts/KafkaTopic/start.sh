#!/bin/bash -e

# FIXME: setup on manager
export PATH=/opt/ext/kafka_2.11-1.0.1/bin:$PATH

KAFKA_IP=$(</tmp/a4c/work/${NODE}/${INSTANCE}/KafkaTopicConnectToBroker/KAFKA_IP)
KAFKA_PORT=$(</tmp/a4c/work/${NODE}/${INSTANCE}/KafkaTopicConnectToBroker/KAFKA_PORT)
ZOOKEEPER_IP=$(</tmp/a4c/work/${NODE}/${INSTANCE}/KafkaTopicConnectToZookeeper/ZOOKEEPER_IP)
ZOOKEEPER_PORT=$(</tmp/a4c/work/${NODE}/${INSTANCE}/KafkaTopicConnectToZookeeper/ZOOKEEPER_PORT)

_topic_name="$TOPIC_NAME"
if [ -z "$TOPIC_NAME" ]; then
  export _topic_name="${INSTANCE}"
fi

export KAFKA_BROKER_ENDPOINT="${KAFKA_IP}:${KAFKA_PORT}"
export ZOOKEEPER_ENDPOINT="${ZOOKEEPER_IP}:${ZOOKEEPER_PORT}"
export TOPIC_NAME="${_topic_name}"

echo "I am '$(whoami)' and my PATH is : ${PATH}"
kafka-topics.sh --create --zookeeper $ZOOKEEPER_ENDPOINT --replication-factor 1 --partitions 1 --topic ${_topic_name}
