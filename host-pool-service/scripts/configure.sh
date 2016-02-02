#! /bin/bash

echo "copying and unzipping the config folder from $pool_config to $WORK_DIR"

tar xzvf $pool_config -C $WORK_DIR
ls ${WORK_DIR}
COMMAND="python ${scripts}/configure.py $WORK_DIR $pool_config $POOL_FILE_NAME"
echo "launching command $COMMAND"
$COMMAND
