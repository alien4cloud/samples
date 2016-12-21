#!/bin/bash -e

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}"

aws rds delete-db-instance --db-instance-identifier $INSTANCE_ID --skip-final-snapshot