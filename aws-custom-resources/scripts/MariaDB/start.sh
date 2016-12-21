#!/bin/bash -e

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}"

aws rds create-db-instance --db-instance-identifier $INSTANCE_ID --db-instance-class $INSTANCE_CLASS --engine mariadb --no-multi-az --storage-type $STORAGE_TYPE --port $PORT --allocated-storage $ALLOCATED_STORAGE --db-name $DB_NAME --master-username $MASTER --master-user-password $PASSWORD --vpc-security-group-ids ${SECURITY_GROUP_IDS} >> /tmp/a4c-maria-db.log

sleep 30

running=false
while [ $running == 'false' ]
do
  output=$(aws rds describe-db-instances --db-instance-identifier $INSTANCE_ID)
  INSTANCE_STATUS=`echo ${output##*DBInstanceStatus}| cut -d '"' -f 3`
  if [[ $INSTANCE_STATUS == "available" ]]
  then
    running=true;
  else
    echo $output >> /tmp/a4c-maria-db.log
    sleep 20
  fi
done

ENDPOINT_ADDRESS=`echo ${output##*Address}| cut -d '"' -f 3`
export ENDPOINT_ADDRESS=$ENDPOINT_ADDRESS
DBINSTANCE_ARN=`echo ${output##*DBInstanceArn}| cut -d '"' -f 3`
export DBINSTANCE_ARN=$DBINSTANCE_ARN
