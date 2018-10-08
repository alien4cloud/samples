#!/bin/bash -e
echo "${NODE}.${duration} sleep: ${duration} sec"
/bin/sleep $duration
export SUBMISSION_ID=$(uuidgen)
