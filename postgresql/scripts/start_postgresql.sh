#!/bin/bash

echo "------------------------ ENV ------------------------"
echo "ENV VAR USED VOLUME_HOME : $VOLUME_HOME"
echo "ENV VAR USED PORT        : $PORT"
echo "ENV VAR USED DB_NAME     : $DB_NAME"
echo "ENV VAR USED DB_USER     : $DB_USER"
echo "---------------------------- ------------------------"

POSTGRESQL_ID=postgresql-9.2

echo "Starting PostgreSQL..."
sudo chkconfig $POSTGRESQL_ID on
sudo chkconfig ntpd on
sudo service ntpd start
sudo service $POSTGRESQL_ID start


RET=1
while [[ RET -ne 0 ]]; do
  echo "=> Waiting for confirmation of PostgreSQL service startup"
  sleep 5
  sudo -u postgres psql -c "select version();"
  RET=$?
done


