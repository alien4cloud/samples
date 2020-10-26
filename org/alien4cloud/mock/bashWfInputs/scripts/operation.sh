#!/bin/bash -e
echo "${NODE}.${duration} sleep: ${duration} sec"
/bin/sleep $duration
echo "Test input with all types of variables"
# simple property
echo "comment : ${comment}"
echo "an_int : ${an_int}"
echo "big_string : ${big_string}"
