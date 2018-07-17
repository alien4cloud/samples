#!/bin/bash -e

# FIXME: setup on manager
export PATH=/opt/ext/kafka_2.11-1.0.1/bin:$PATH

kafka-topics.sh --delete --zookeeper $ZOOKEEPER_ENDPOINT --topic ${TOPIC_NAME}
