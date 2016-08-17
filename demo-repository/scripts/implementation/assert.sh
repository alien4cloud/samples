#!/bin/bash -e

echo "I'm a remote script"

if [ -z "$http_artifact" ]; then
    echo "remote_artifact is not set"
    touch /var/www/artifact
    exit 1
else
    echo "I have access to the artifact http_artifact at ${http_artifact}"
fi

if [ -z "$git_artifact" ]; then
    echo "git_artifact is not set"
    sudo touch /var/www/git
    exit 1
else
    echo "I have access to the artifact git_artifact at ${git_artifact}"
fi
