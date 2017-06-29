#!/bin/bash
env_file=/tmp/$$.env
printenv > $env_file
wget --timeout=30 -t 3 -S -q "http://a4c_registry/log_node_operation.php?node=$NODE&instance=$INSTANCE&operation=stop" --post-file=$env_file
exit 0
