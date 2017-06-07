#!/bin/bash -e
source $commons/commons.sh

install_packages samba
require_bin "smbd nmbd"

sudo service smbd stop
sudo service nmbd stop
