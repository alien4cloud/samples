#! /bin/bash
# reset step state
curl -b cookie.txt  -XPATCH -s -H 'Content-Type: application/json' ${A4C_URL}/rest/latest/executions/${EXEC_ID}/step/${STEPNAME} -d{}
