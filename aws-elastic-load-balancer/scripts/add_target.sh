#!/bin/bash -e

export AWS_ACCESS_KEY_ID="${aws_access_key}"
export AWS_SECRET_ACCESS_KEY="${aws_secret_key}"
export AWS_DEFAULT_REGION="${region}"

aws elb register-instances-with-load-balancer --load-balancer-name ${lb_name} --instances ${instance_id}
