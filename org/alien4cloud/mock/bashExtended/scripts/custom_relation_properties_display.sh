#!/bin/bash -e
echo "relation properties values"
echo "field 1 ${field1}"
echo "field 2 ${field2}"
echo "target capability properties"
echo "prop1 ${prop1}"

echo "${SOURCE_NODE}-${TARGET_NODE}.${operation} sleep: ${duration} sec"
/bin/sleep $duration

