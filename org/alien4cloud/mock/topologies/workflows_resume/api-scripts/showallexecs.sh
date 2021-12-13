#! /bin/bash
# show all executions for a deployment
curl -b cookie.txt  -s -H 'Content-Type: application/json' ${A4C_URL}/rest/latest/executions/search?deploymentId=${DEPLOY_ID} | jq .
