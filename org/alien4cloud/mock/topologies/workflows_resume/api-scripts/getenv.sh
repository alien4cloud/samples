#! /bin/bash
# get environment ID
curl -b cookie.txt -s -H 'Content-Type: application/json' ${A4C_URL}/rest/latest/applications/${APP_ID}/environments/search -X POST -d@env.json | jq -r '.data.data[0].id'
