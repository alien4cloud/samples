#!/bin/bash

# FIXME: setup on manager
export PATH=$PATH:/opt/ext/hadoop/hadoop-2.9.0/bin
export PATH=$PATH:/opt/ext/spark/spark-2.2.1-bin-hadoop2.7/bin
export JAVA_HOME=/usr/java/jre1.8.0_45

echo "Pushing $jar_file to ${HDFS_URL}/data/$INSTANCE.jar"
hdfs dfs -Dfs.defaultFS=${HDFS_URL} -Ddfs.client.use.datanode.hostname=true -put $jar_file /data/$INSTANCE.jar
if [ "$?" != "0" ]; then
  echo "Not able to push $jar_file to ${HDFS_URL}/data/$INSTANCE.jar, something went wrong"
  exit 1
else
  echo "$jar_file pushed to ${HDFS_URL}/data/$INSTANCE.jar"
fi

CMD=$(cat <<'EOF'
spark-submit \
  --class $CLASS_NAME \
  --master $SPARK_URL \
  --deploy-mode cluster \
  --executor-memory ${MEMORY}G \
  --total-executor-cores $CORES \
  ${HDFS_URL}/data/$INSTANCE.jar \
  10 \
  $INPUT_REPOSITORY_URL \
  $APP_ARGS \
  $OUTPUT_KAFKA_BROKER_ENDPOINT \
  $OUTPUT_TOPIC_NAME 2>&1 | grep submissionId | cut -d':' -f2 | sed -e 's/^ "//' | sed -e 's/",//'
EOF
)

remove_file() {
  echo "Deleting remote file at ${HDFS_URL}/data/$INSTANCE.jar"
  hdfs dfs -Dfs.defaultFS=${HDFS_URL} -Ddfs.client.use.datanode.hostname=true -rm /data/$INSTANCE.jar
}

submissionId=$(eval $CMD)
if [ "$?" != "0" ]; then
  echo "Not able to submit job on spark, something went wrong"
  remove_file
  exit 1
fi
if [ -z "$submissionId" ]; then
  echo "No submissionId return after spark-submit, something went wrong"
  remove_file
  exit 1
fi
echo "Driver submited, submissionId is $submissionId"
export SPARK_SUBMISSION_ID="$submissionId"
