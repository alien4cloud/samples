#!/bin/bash -e

echo "Joining cluster by contacting following member ${CONSUL_SERVER_ADDRESS}"
sudo consul join ${CONSUL_SERVER_ADDRESS}

echo "Consul has following members until now"
sudo consul members