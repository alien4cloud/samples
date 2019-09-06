#!/bin/bash -e
echo "Running Job <$TOSCA_JOB_ID> that should fail"
export TOSCA_JOB_STATUS="FAILED"
