#! /bin/bash

if [ -z "$pool_config" ]; then
  echo 'undefined variable $pool_config'
  exit 10
fi

JSON_CONDIF_FILE="${WORK_DIR}/config.json"
echo "Converting yaml config file $pool_config to json file $JSON_CONDIF_FILE"

python --version
if [ $? -ne 0 ] ; then
  echo 'python is required'
  exit 11
fi

# We will suppose that python is available on the machine
cat $pool_config | python -c 'import sys, yaml, json; print json.dumps(yaml.load(sys.stdin.read()))' > $JSON_CONDIF_FILE
