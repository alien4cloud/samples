#!/bin/bash

# FIXME: setup on manager
export PATH=$PATH:/opt/ext/hadoop/hadoop-2.9.0/bin
export PATH=$PATH:/opt/ext/spark/spark-2.2.1-bin-hadoop2.7/bin
export JAVA_HOME=/usr/java/jre1.8.0_45

wait_for_termination() {

    submissionId=$1
    sparUrl=$2

    finished=false
    result=0

    echo "Waiting for driver ${submissionId} to be in a ended state"
    for i in $(seq 1 720)
    do
        status=$(spark-submit --status $submissionId --master $sparUrl 2>&1 | grep driverState | cut -d':' -f2 | sed -e 's/^ "//' | sed -e 's/",//')
        echo "Driver ${submissionId} is currently in state $status"
        case "$status" in
            "ERROR" | "KILLED" | "FAILED")
              finished=true
              result=1
              ;;
            "FINISHED")
              finished=true
              result=0
              ;;
        esac
        if [ ${finished} = true ] ; then
            echo "Returning $result"
            return $result
        else
            echo "Driver ${submissionId} still running. waiting 5 seconds..."
            sleep 5
        fi
    done
    if [ ${finished} = false ]; then
        echo "Driver ${submissionId} not ended. timeout ended."
        return 1
    fi
}

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
  $INSTANCE $INPUT_FILE_URL $OUTPUT_FILE_URL \
  $APP_ARGS 2>&1 | grep submissionId | cut -d':' -f2 | sed -e 's/^ "//' | sed -e 's/",//'
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
wait_for_termination $submissionId $SPARK_URL
result=$?
echo "Result of driver submission is $result"
remove_file
exit $result
