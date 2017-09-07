#!/bin/bash

echo ""
echo "Executing relationship operation: ${RELATIONSHIP_TYPE}_${OPERATION}"
echo ""
env | sort

export TYPE=$RELATIONSHIP_TYPE