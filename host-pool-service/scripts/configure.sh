#! /bin/bash

echo "unzipping the config folder from $pool_config to $WORK_DIR"

tar xzvf $pool_config -C $WORK_DIR

JSON_CONDIF_FILE="${WORK_DIR}/config.json"

echo  "generating json config to  $JSON_CONDIF_FILE"
echo -e "{\n  'pool': ${WORK_DIR}/${POOL_FILE_NAME}\n}" > $JSON_CONDIF_FILE
