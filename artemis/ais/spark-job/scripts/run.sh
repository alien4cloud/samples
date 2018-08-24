#!/usr/bin/env bash

echo "MAIN_JAR_URL=${MAIN_JAR_URL}" #hdfs:///aisliv/fatjar/bigdata-toolbox-spark-1.0.00-SNAPSHOT-jar-with-dependencies.jar
echo "MAIN_CLASS=${MAIN_CLASS}" #fr.cls.bigdata.toolbox.spark.raw.Raw1ToRaw2
echo "HIVE_SITE_URL=${HIVE_SITE_URL}" #http://hdfs-5.novalocal/hdfs-config/hive-site.xml
echo "DRIVER_MEMORY=${DRIVER_MEMORY}"
echo "EXECUTOR_MEMORY=${EXECUTOR_MEMORY}"
echo "APP_ARGS=${APP_ARGS}" #day-2018001 0

#dcos --log-level=INFO spark --verbose run --submit-args="--class fr.cls.bigdata.toolbox.spark.raw.Raw1ToRaw2 --driver-memory 1G --executor-memory 1G --conf spark.kryoserializer.buffer.max=512M hdfs:///aisliv/fatjar/bigdata-toolbox-spark-1.0.00-SNAPSHOT-jar-with-dependencies.jar day-2018001 0"

WAIT="true"
tmpnam=$(mktemp)
# Running the job
dcos spark run --submit-args="
    --conf spark.mesos.uris=${HIVE_SITE_URL}
    --conf spark.driver.extraClassPath=./
    --conf spark.executor.extraClassPath=./
    --class ${MAIN_CLASS}
    --driver-memory ${DRIVER_MEMORY}G
    --executor-memory ${EXECUTOR_MEMORY}G
    --conf spark.kryoserializer.buffer.max=512M
    ${MAIN_JAR_URL} ${APP_ARGS}" | tee "${tmpnam}"
ret=${PIPESTATUS[0]}
if [ $ret -ne 0 ]; then
    echo "Failed to run job" >&2
    exit 1
fi
submission_id=$(cat "${tmpnam}" | grep 'Submission id' | sed 's/^.*Submission id\: \(.*\)$/\1/g')
if [ -z "$submission_id" ]; then
    echo "Could not find submission id" >&2
    exit 1
fi

echo "Submission id: ${submission_id}"

if [ "$WAIT" == "true" ]; then
    isdone=false
    while [ "$isdone" != true ]; do
        status=$(dcos spark status --skip-message "${submission_id}" | grep state | sed 's/.*state\: \([^\s\\]*\).*/\1/g')
        echo "status: $status"
        case "$status" in
            TASK_FINISHED|TASK_FAILED)isdone=true;;
            *)sleep 2;;
        esac
    done
    if [ "${status}" == "TASK_FAILED" ]; then
        exit 1
    fi
fi