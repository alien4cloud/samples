#!/bin/bash

_error(){
    echo "$1" 1>&2
    exit 1
}

[ -d "${WORK_DIR}" ] || \
    _error "Host pool's directory '${WORK_DIR}' does not exist!"

echo "Deleting directory: ${WORK_DIR}"
rm -rvf "${WORK_DIR}"
