#! /bin/bash
# show last execution details 
curl -b cookie.txt  -s -H 'Content-Type: application/json' ${A4C_URL}/rest/latest/workflow_execution/${DEPLOY_ID} | jq .
