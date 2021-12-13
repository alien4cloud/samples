#! /bin/bash
# resume last execution
curl -b cookie.txt -XPOST -H 'Content-Type: application/json' ${A4C_URL}/rest/latest/deployments/${DEPLOY_ID}/resume-last-execution -d{}
