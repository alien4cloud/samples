#!/bin/bash
ansible-playbook -i 34.247.177.225, install-a4c.yml --private-key ~/work/env/aws/keys/vicos-awsproductteam.pem --user centos --extra-vars "@inputs.json" -v
