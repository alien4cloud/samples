#!/bin/bash -e
source $commons/commons.sh

require_bin "smbd nmbd"

sudo service smbd restart
sudo service nmbd restart
