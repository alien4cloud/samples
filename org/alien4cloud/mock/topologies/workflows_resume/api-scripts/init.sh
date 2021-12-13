#! /bin/bash
# Connects to A4C and get IDs
source ./setvars.sh
./login.sh
export ENVID=$(./getenv.sh)
export DEPLOY_ID=$(./getdeploy.sh)
export EXEC_ID=$(./getexec.sh)
