#!/bin/sh -x

# Configure JDBC Driver
TOMCAT_SETENV_FILE=/opt/tomcat/bin/setenv.sh

if [ -z "$DB_ENDPOINT" ] ; then
  DB_ENDPOINT="$DB_IP:$DB_PORT"
fi

grep $DB_ENDPOINT $TOMCAT_SETENV_FILE >/dev/null 2>&1
if [ $? -eq 0 ] ; then
  echo "jdbc already configured for petclinic"
else
  echo "export CATALINA_OPTS=\"\$CATALINA_OPTS -Djdbc.initLocation=classpath:db/postgresql/initDB.sql" \
  "-Djdbc.dataLocation=classpath:db/postgresql/populateDB.sql" \
  "-Djdbc.driverClassName=org.postgresql.Driver" \
  "-Djdbc.url='jdbc:postgresql://$DB_ENDPOINT/$DB_NAME?useUnicode=true&characterEncoding=UTF-8'" \
  "-Djdbc.username=$DB_USER" \
  "-Djdbc.password=$DB_PASS" \
  "-Djpa.database=POSTGRESQL\"" | sudo tee $TOMCAT_SETENV_FILE
fi

# Restart tomcat to read the JDBC properties
sudo /opt/tomcat/bin/shutdown.sh

# Ensure that tomcat is really shutdown
while [ $(ps -ef | grep -v grep | grep catalina | wc -l) -ne 0 ] ; do
  echo "Ending catalina process... "
  sleep 2
done

sudo /opt/tomcat/bin/startup.sh