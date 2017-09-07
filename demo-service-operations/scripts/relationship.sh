#!/bin/bash

echo ""
echo "${RELATIONSHIP_TYPE}_${OPERATION}"
echo ""
env | sort

export TYPE=$RELATIONSHIP_TYPE