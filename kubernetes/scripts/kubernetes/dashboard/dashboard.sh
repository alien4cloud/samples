#!/bin/bash

# Args
if [ -z "$MASTER_IP" ] ; then
  MASTER_IP=localhost
fi

if [ -z "$NAMESPACE" ] ; then
  NAMESPACE=kube-system
fi

if [ ! -f "$dashboard_rc_file" ] ; then
  dashboard_rc_file="./dashboard-rc.yaml"
fi

if [ ! -f "$dashboard_svc_file" ] ; then
  dashboard_svc_file="./dashboard-svc.yaml"
fi

# Functions
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

function create_k8s_resource_if_not_exist {
  RESOURCE_TYPE=$1
  RESOURCE_NAME=$2
  TEMPLATE_FILE=$3

  if [ -z $RESOURCE_TYPE -o -z $RESOURCE_NAME -o -z $TEMPLATE_FILE ] ; then
    echo "Missing args... Usage: $0 [RESOURCE_TYPE] [RESOURCE_NAME] [TEMPLATE_FILE]"
    exit 1
  fi
  if [ ! -f $TEMPLATE_FILE ] ; then
    echo "Cannot found $TEMPLATE_FILE (pwd=$pwd)"
    exit 1
  fi

  http_code=$(curl -s -o /dev/null -w '%{http_code}' $BASE_URL/$RESOURCE_TYPE/$RESOURCE_NAME)

  if [ $http_code != $HTTP_OK_CODE ] ; then
    ## Create Replication controller
    http_code=$(curl -s -o /dev/null -w '%{http_code}' -H "Content-type: application/yaml" -X POST $BASE_URL/$RESOURCE_TYPE --data-binary @$TEMPLATE_FILE)
    if [ $http_code != $HTTP_CREATED_CODE -a $http_code != $HTTP_ALREADY_EXISTS ] ; then
      echo "Failed to create $RESOURCE_NAME $RESOURCE_TYPE"
      exit 1
    fi

    ## Checks
    wait_http_code "$BASE_URL/$RESOURCE_TYPE/$RESOURCE_NAME" $HTTP_OK_CODE > /dev/null

    echo "Created resource $RESOURCE_NAME $RESOURCE_TYPE"
  else
    echo "Resource Already exists $RESOURCE_NAME $RESOURCE_TYPE"
  fi
}

# Vars
HTTP_OK_CODE=200
HTTP_CREATED_CODE=201
HTTP_ALREADY_EXISTS=409

BASE_URL=http://$MASTER_IP:8080/api/v1/namespaces/$NAMESPACE

# Create the DNS replication controller
create_k8s_resource_if_not_exist "replicationcontrollers" "kubernetes-dashboard" $dashboard_rc_file

# Create the DNS service
create_k8s_resource_if_not_exist "services" "kubernetes-dashboard" $dashboard_svc_file
