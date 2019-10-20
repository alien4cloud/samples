#!/bin/bash -e

# TODO use ${log_length} to limit or maximise log size
/bin/more ${data}

echo "custom interface"
echo "${NODE}.${duration} sleep: ${duration} sec"
/bin/sleep $duration
echo "Display of comment "
# simple property
echo "Comment  : ${comment}"



