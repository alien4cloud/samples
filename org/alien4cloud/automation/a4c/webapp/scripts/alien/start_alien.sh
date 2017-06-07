#!/bin/bash -e
source $commons/commons.sh

require_envs "SERVER_PROTOCOL ALIEN_PORT"

ALIEN_URL="${SERVER_PROTOCOL}://localhost:${ALIEN_PORT}/rest/admin/health"

get_response_code() {

  url=$1

  set +e

  curl_cmd=$(which curl)
  wget_cmd=$(which wget)

  if [ ! -z ${curl_cmd} ]; then
    response_code=$(curl -s --insecure -o /dev/null -w "%{http_code}" ${url})
  elif [ ! -z ${wget_cmd} ]; then
    response_code=$(wget --spider --no-check-certificate -S "${url}" 2>&1 | grep "HTTP/" | awk '{print $2}' | tail -1)
  else
    echo "Failed to retrieve response code from ${url}: Neither 'curl' nor 'wget' were found on the system"
    exit 1;
  fi

  set -e

  echo ${response_code}

}

wait_for_server() {

  url=$1
  server_name=$2

  started=false

  echo "Running ${server_name} liveness detection on url ${url}"

  for i in $(seq 1 360)
  do
    response_code=$(get_response_code ${url})
    echo "[GET] ${url} ${response_code}"
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

cd /opt/alien4cloud/alien4cloud
# sudo mkdir -p WEB-INF/lib
# sudo mv lib/* WEB-INF/lib/
# WAR_FILE=$(ls alien4cloud-ui-*.war)
# sudo jar -uf0 $WAR_FILE WEB-INF/lib/*
# sudo rm -rf WEB-INF
sudo mkdir -p logs
sudo chmod 777 logs
nohup sudo bash -c "for f in `ls /etc/alien4cloud/env`; do source /etc/alien4cloud/env/\$f; done && /opt/alien4cloud/alien4cloud/alien4cloud.sh ${APP_ARGS} >> logs/vm.out 2>&1 &" >> logs/start.out 2>&1 &

wait_for_server $ALIEN_URL 'alien4cloud'
