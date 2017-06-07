#!/bin/bash

# source the utility libraries we want to provide for this artifact execution
source commons.sh
source ssl.sh

# call the actual artifact
. $1 $@
