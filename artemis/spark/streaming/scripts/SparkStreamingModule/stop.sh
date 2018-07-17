#!/bin/bash -e

# FIXME: setup on manager
export PATH=$PATH:/opt/ext/hadoop/hadoop-2.9.0/bin
export PATH=$PATH:/opt/ext/spark/spark-2.2.1-bin-hadoop2.7/bin
export JAVA_HOME=/usr/java/jre1.8.0_45

spark-submit --kill $SPARK_SUBMISSION_ID --master $SPARK_URL
