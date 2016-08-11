#!/bin/bash -e

echo "I'm a remote script"

if [ -z "$remote_artifact" ]; then
    echo "remote_artifact is not set"
    exit 1
else
    echo "I have access to the artifact remote_artifact at ${remote_artifact}"
fi
