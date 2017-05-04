#!/bin/bash -x

if [ -z "$DB_NAME" ] ; then
  DB_NAME="petclinic"
fi
if [ -z "$DB_USER" ] ; then
  DB_USER="petclinic"
fi
if [ -z "$DB_PASSWORD" ] ; then
  DB_PASSWORD="petclinic"
fi

echo "------------------------ ENV ------------------------"
#echo "ENV VAR USED PORT        : $PORT"
echo "ENV VAR USED DB_NAME     : $DB_NAME"
echo "ENV VAR USED DB_USER     : $DB_USER"
echo "ENV VAR USED DB_PASSWORD : $DB_PASSWORD"
echo "---------------------------- ------------------------"


function StartPostgreSQL {
  echo "Starting PostgreSQL..."
  sudo chkconfig $POSTGRESQL_ID on
  sudo chkconfig ntpd on
  sudo service ntpd start
  sudo service $POSTGRESQL_ID start

  check_command="sudo -u postgres psql -c \"select version();\""
  max_retries=5
  retries=0
  echo "$check_command" | sh
  current_code=$?
  while [ $current_code -ne 0 -a $retries -lt $max_retries ] ; do
    echo "=> Waiting for confirmation of PostgreSQL service startup ($retries/$max_retries)"
    sleep 5
    retries=$(($retries+1))
    echo "$check_command" | sh
    current_code=$?
  done
}


function InitPostgreSQLDb {
  # create database DB_NAME
  if [ "$DB_NAME" ]; then
    echo "INIT DATABASE $DB_NAME"
    sudo -u postgres createdb $DB_NAME
  fi

  # create user and give rights
  if [ "$DB_USER" ]; then
    echo "CREATE USER $DB_USER AND GRAND RIGHTS ON $DB_NAME"
# looks like with the possibility to create a DB, we may get rid of the "base database" here. we'll see

    sudo -u postgres psql <<EOF
    CREATE USER ${DB_USER} PASSWORD '$DB_PASSWORD';
    GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO ${DB_USER} WITH GRANT OPTION;
    ALTER USER ${DB_USER} CREATEDB;
    ALTER DATABASE $DB_NAME OWNER TO $DB_USER;
EOF

  fi
}


CURRENT_PATH=`dirname "$0"`
POSTGRESQL_ID=postgresql-9.5
POSTGRESQL_DATA_DIR=/var/lib/pgsql/9.5/data

sudo /usr/pgsql-9.5/bin/postgresql95-setup initdb

sudo bash << EOF
  sed -i "s/#listen_addresses = 'localhost'/listen_addresses = \'*\'/" ${POSTGRESQL_DATA_DIR}/postgresql.conf
  echo "host all all  0.0.0.0/0  md5" > $POSTGRESQL_DATA_DIR/pg_hba.conf.new
  echo "local all all trust" >> $POSTGRESQL_DATA_DIR/pg_hba.conf.new
  mv -f $POSTGRESQL_DATA_DIR/pg_hba.conf $POSTGRESQL_DATA_DIR/pg_hba.conf.bak
  mv -f $POSTGRESQL_DATA_DIR/pg_hba.conf.new $POSTGRESQL_DATA_DIR/pg_hba.conf
EOF

echo "=> PostgreSQL database initialized !"

# Finally start PostgreSQL with new configuration
StartPostgreSQL
InitPostgreSQLDb
