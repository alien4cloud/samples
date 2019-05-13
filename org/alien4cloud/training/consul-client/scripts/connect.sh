#!/bin/sh -e

echo "CONSUL_URL: $CONSUL_URL"
echo "KEY_NAME: $KEY_NAME"
echo "KEY_VALUE: $KEY_VALUE"

curl --request PUT --data "${KEY_VALUE}" "${CONSUL_URL}/v1/kv/${KEY_NAME}"
