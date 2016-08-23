#!/bin/bash -e

echo "I'm a remote script"

if [ -z "$http_artifact" ]; then
    echo "remote_artifact is not set"
    exit 1
else
    echo "I have access to the artifact http_artifact at ${http_artifact}"
    sudo touch /var/www/http
fi

if [ -z "$git_artifact" ]; then
    echo "git_artifact is not set"
    exit 1
else
    echo "I have access to the artifact git_artifact at ${git_artifact}"
    sudo touch /var/www/git
fi

if [ -z "$maven_artifact" ]; then
    echo "maven_artifact is not set"
    exit 1
else
    echo "I have access to the artifact maven_artifact at ${maven_artifact}"
    sudo touch /var/www/maven
fi
