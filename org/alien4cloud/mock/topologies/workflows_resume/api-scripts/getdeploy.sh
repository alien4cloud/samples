#! /bin/bash
# get deployment ID
curl -b cookie.txt -s -H 'Content-Type: application/json' ${A4C_URL}/rest/latest/applications/${APP_ID}/environments/${ENVID}/active-deployment | jq -r '.data.id'
