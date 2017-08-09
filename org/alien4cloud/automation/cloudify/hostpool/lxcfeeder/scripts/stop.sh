#!/bin/bash

LIST=`curl $HOSTPOOL_ENDPOINT/hosts?tags=$TAG`
KEY="id"
IDS=`echo $LIST|awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/\042'$KEY'\042/){print $(i+1)}}}' | tr -d '"'`
for id in $IDS
do
  curl -X DELETE $HOSTPOOL_ENDPOINT/host/$id
done
