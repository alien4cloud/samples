#!/bin/bash

# args:
# $1 key
# $2 value

tmp="$1=$2"
export $tmp

if [ -z $TARGETS ]; then
  tmp2="TARGETS=$1"
else
  tmp2="TARGETS=$1,$SOURCES"
fi
export $tmp2
