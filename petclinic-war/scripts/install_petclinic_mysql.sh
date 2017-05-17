#!/bin/sh -x

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

# Ensure that tomcat is really shutdown
while [ $(ps -ef | grep -v grep | grep catalina | wc -l) -ne 0 ] ; do
  echo "Ending catalina process... "
  sleep 2
done

sudo /opt/tomcat/bin/startup.sh