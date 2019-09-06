#!/bin/bash -e
echo "Submitting job"
# The TOSCA_JOB_ID is required by Yorc in order to inject it in run operation
export TOSCA_JOB_ID="JOB:$(uuidgen)"
# this JOB_ID is a real attribute and is shown in A4C UI
export JOB_ID="$TOSCA_JOB_ID"
echo "TOSCA_JOB_ID is <$TOSCA_JOB_ID>, JOB_ID is <$JOB_ID>"
