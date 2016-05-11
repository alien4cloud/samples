#!/bin/bash

function get_response_code() {

    port=$1

    set +e

    curl_cmd=$(which curl)
    wget_cmd=$(which wget)

    if [[ ! -z ${curl_cmd} ]]; then
        response_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${port}/hosts)
    elif [[ ! -z ${wget_cmd} ]]; then
        response_code=$(wget --spider -S "http://localhost:${port}/hosts" 2>&1 | grep "HTTP/" | awk '{print $2}' | tail -1)
    else
        echo "Failed to retrieve response code from http://localhost:${port}/hosts --> Neither 'cURL' nor 'wget' were found
         on the system"
        exit 1;
    fi

    set -e

    echo ${response_code}

}


function wait_for_server() {

    port=$1
    server_name=$2

    started=false

    echo "Running ${server_name} liveness detection on port ${port}"

    for i in $(seq 1 5)
    do
        response_code=$(get_response_code ${port})
        echo "[GET] http://localhost:${port}/hosts ${response_code}"
        if [ ${response_code} -eq 200 ] ; then
            started=true
            break
        else
            echo "${server_name} has not started. waiting..."
            sleep 1
        fi
    done
    if [ ${started} = false ]; then
        echo "${server_name} failed to start: $(cat ${WORK_DIR}/gunicorn.log)"
        exit 1
    fi
}



cd ${WORK_DIR}
command="gunicorn --workers=5 --pid=${WORK_DIR}/gunicorn.pid --log-level=INFO --log-file=${WORK_DIR}/gunicorn.log --bind 0.0.0.0:${PORT} --daemon cloudify_hostpool.rest.service:app"
echo "Starting cloudify-host-pool-service with command: ${command}"
${command}

wait_for_server ${PORT} 'Host-Pool-Service'

config_path=${WORK_DIR}/config.json
echo "Initialize host pool service"
curl -v -X POST -H "Content-Type: application/json" -d @$config_path http://localhost:8080/hosts
