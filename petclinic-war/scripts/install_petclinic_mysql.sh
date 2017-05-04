#!/bin/sh -x

# Wait petclinic to be deployed
max_retries=10
retries=0
PETCLINIC_DIR=/opt/tomcat/webapps/$CONTEXT_PATH
while [ ! -d "$PETCLINIC_DIR" -a $retries -lt $max_retries ] ; do
  echo "Waiting petclinic. Wait and retry ($retries/$max_retries)"
  sleep 10
  retries=$(($retries+1))
done

# Override the initDB.sql script (the original script creates DB & Users but current user don't have the rights)
sudo cp -r $mysql_dir/* $PETCLINIC_DIR/WEB-INF/classes/db/mysql

# Setup MySql/JDBC Connector properties
TOMCAT_SETENV_FILE=/opt/tomcat/bin/setenv.sh

if [ -z "$DB_ENDPOINT" ] ; then
  DB_ENDPOINT="$DB_IP:$DB_PORT"
fi

grep $DB_ENDPOINT $TOMCAT_SETENV_FILE >/dev/null 2>&1
if [ $? -eq 0 ] ; then
  echo "jdbc already configured for petclinic"
  exit 0
fi

echo "export CATALINA_OPTS=\"\$CATALINA_OPTS -Djdbc.initLocation=classpath:db/mysql/initDB.sql" \
"-Djdbc.dataLocation=classpath:db/mysql/populateDB.sql" \
"-Djdbc.driverClassName=com.mysql.jdbc.Driver" \
"-Djdbc.url='jdbc:mysql://$DB_ENDPOINT/$DB_NAME?useUnicode=true&characterEncoding=UTF-8'" \
"-Djdbc.username=$DB_USER" \
"-Djdbc.password=$DB_PASS" \
"-Djpa.database=MYSQL\"" >> $TOMCAT_SETENV_FILE

# Restart tomcat to read the JDBC properties
sudo /opt/tomcat/bin/shutdown.sh
sleep 5
sudo /opt/tomcat/bin/startup.sh