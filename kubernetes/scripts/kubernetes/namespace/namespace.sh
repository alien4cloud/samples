#!/bin/bash 

# Needs the artifact scripts/kubernetes/resources/namespace.yaml

#Args
if [ -z "$MASTER_IP" ] ; then
  MASTER_IP=localhost
fi

if [ -z "$NAMESPACE" ] ; then
  NAMESPACE=kube-system
fi

if [ ! -f "$namespace_pod_file" ] ; then
  namespace_pod_file=./namespace.yaml
fi

function wait_http_code {
  url=$1
  expected_code=$2
  current_code=9999

  max_retries=5
  retries=0

  curl_cmd="curl -s -o /dev/null -w '%{http_code}' $url"

  current_code=$(echo $curl_cmd | sh)
  while [ $current_code != $expected_code -a $retries -lt $max_retries ] ; do
    echo "Requesting $url. Wait and retry ($retries/$max_retries)"
    sleep 5
    retries=$(($retries+1))
    current_code=$(echo $curl_cmd | sh)
  done

  if [ $retries = $max_retries ] ; then
    echo "Exit with error while executing $curl_cmd. Expected http code=$expected_code, got $current_code."
    exit 1
  fi

  echo $current_code
}

NAMESPACE_BASE_URL=http://$MASTER_IP:8080/api/v1/namespaces

HTTP_OK_CODE=200
HTTP_CREATED_CODE=201
HTTP_ALREADY_EXISTS=409

# To delete a namespace
# curl -X DELETE http://localhost:8080/api/v1/namespaces/kube-system

# Check existence of the namespace
http_code=$(curl -s -o /dev/null -w '%{http_code}' $NAMESPACE_BASE_URL/$NAMESPACE)

if [ $http_code != $HTTP_OK_CODE ] ; then
  http_code=$(curl -s -o /dev/null -w '%{http_code}' -H "Content-type: application/yaml" -X POST $NAMESPACE_BASE_URL --data-binary @${namespace_pod_file})
  if [ $http_code != $HTTP_OK_CODE -a $http_code != $HTTP_CREATED_CODE -a $http_code != $HTTP_ALREADY_EXISTS ] ; then
    echo "Failed to create namespace"
    exit 1
  fi
fi

# Checks
wait_http_code "$NAMESPACE_BASE_URL/$NAMESPACE" $HTTP_OK_CODE > /dev/null
wait_http_code "$NAMESPACE_BASE_URL/$NAMESPACE/serviceaccounts" $HTTP_OK_CODE > /dev/null

echo "Created namespace $NAMESPACE"
