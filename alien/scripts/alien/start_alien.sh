#!/bin/bash -e

ALIEN_PORT=8088

get_response_code() {

  port=$1

  set +e

  curl_cmd=$(which curl)
  wget_cmd=$(which wget)

  if [ ! -z ${curl_cmd} ]; then
    response_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${port})
  elif [ ! -z ${wget_cmd} ]; then
    response_code=$(wget --spider -S "http://localhost:${port}" 2>&1 | grep "HTTP/" | awk '{print $2}' | tail -1)
  else
    echo "Failed to retrieve response code from http://localhost:${port}: Neither 'curl' nor 'wget' were found on the system"
    exit 1;
  fi

  set -e

  echo ${response_code}

}

wait_for_server() {

  port=$1
  server_name=$2

  started=false

  echo "Running ${server_name} liveness detection on port ${port}"

  for i in $(seq 1 360)
  do
    response_code=$(get_response_code ${port})
    echo "[GET] http://localhost:${port} ${response_code}"
    if [ ${response_code} -eq 200 ] ; then
      started=true
      break
    else
      echo "${server_name} has not started. waiting 5 seconds..."
      sleep 5
    fi
  done
  if [ ${started} = false ]; then
    echo "${server_name} failed to start. timeout ended."
    exit 1
  fi
}

sudo /etc/init.d/alien start
wait_for_server $ALIEN_PORT 'alien4cloud'
