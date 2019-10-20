#!/bin/bash -e
echo "${NODE}.${duration} sleep: ${duration} sec"
echo "${NODE}.${duration} sleep: ${duration} sec" >> /tmp/operation.log
/bin/sleep $duration