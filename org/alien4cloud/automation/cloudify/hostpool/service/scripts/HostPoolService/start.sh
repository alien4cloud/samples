#!/bin/bash -e

sudo ~/cloudify-hostpool-service-pkg/bin/start.sh

echo ""
echo ""
echo "Hostpool started."
echo "   curl http://localhost:$SVC_PORT/hosts"
curl http://localhost:$SVC_PORT/hosts 
