#!/bin/bash -e

echo "Creating directory ${WORK_DIR}"
mkdir -p ${WORK_DIR}
echo "created directory"
cd ${WORK_DIR}

echo "Installing gunicorn"
pip install gunicorn==18.0
echo "Installing pyyaml"
pip install pyyaml==3.10
echo "Installing host-pool-service sources from ${SOURCE_CODE}"
pip install ${SOURCE_CODE}
