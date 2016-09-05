#!/bin/bash

if [ -z "$local_war" ]; then
    echo "local_war is not set"
    exit 1
else
    echo "local_war is ${local_war}"
fi

if [ -z "$uploaded_war" ]; then
    echo "uploaded_war is not set"
    exit 1
else
    echo "uploaded_war is ${uploaded_war}"
fi

if [ -z "$nested_uploaded_war" ]; then
    echo "nested_uploaded_war is not set"
    exit 1
else
    echo "nested_uploaded_war is ${nested_uploaded_war}"
fi

if [ -z "$remote_war" ]; then
    echo "remote_war is not set"
    exit 1
else
    echo "remote_war is ${remote_war}"
fi
