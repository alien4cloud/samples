#! /bin/bash
# resume one execution
curl -b cookie.txt -XPOST -H 'Content-Type: application/json' ${A4C_URL}/rest/latest/executions/${EXEC_ID}/resume -d{}
