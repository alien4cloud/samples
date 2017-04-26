#!/bin/bash -e

# That kind of goes beyond a simple "start" but as the manager bootstrap is both an install and start it is better to place it here so configuration and relationship configuration can be done before.

echo "Bootstraping manager node"

cfy bootstrap simple-manager-blueprint.yaml -i inputs.yaml

echo "Manager node has been bootstraped"
