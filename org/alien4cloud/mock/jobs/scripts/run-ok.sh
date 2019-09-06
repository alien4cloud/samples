#!/bin/bash -e
echo "Running Job <$TOSCA_JOB_ID> that should success (sleeping $duration sec)"

/bin/sleep $duration

export TOSCA_JOB_STATUS="COMPLETED"
