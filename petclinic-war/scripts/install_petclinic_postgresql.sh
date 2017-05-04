#!/bin/sh -x

# wait petclinic to be deployed
max_retries=10
retries=0
PETCLINIC_DIR=/opt/tomcat/webapps/$CONTEXT_PATH
while [ ! -d "$PETCLINIC_DIR" -a $retries -lt $max_retries ] ; do
  echo "Waiting petclinic. Wait and retry ($retries/$max_retries)"
  sleep 10
  retries=$(($retries+1))
done

# Prepare petclinic (FIXME)
sudo curl https://jdbc.postgresql.org/download/postgresql-42.0.0.jre7.jar -o $PETCLINIC_DIR/WEB-INF/lib/postgresql-42.0.0.jre7.jar 
sudo cp -r $postgresql_dir $PETCLINIC_DIR/WEB-INF/classes/db/postgresql

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
sleep 5
sudo /opt/tomcat/bin/startup.sh