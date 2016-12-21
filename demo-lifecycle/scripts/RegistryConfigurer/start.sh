#!/bin/bash
if [ ! -z "$REGISTRY_HOST" ]; then
	sudo bash -c "echo '$REGISTRY_HOST a4c_registry' >> /etc/hosts"
fi