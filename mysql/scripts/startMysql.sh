#!/bin/bash

echo "------------------------ ENV ------------------------"
echo "ENV VAR USED VOLUME_HOME : $VOLUME_HOME"
echo "ENV VAR USED PORT        : $PORT"
echo "ENV VAR USED DB_NAME     : $DB_NAME"
echo "ENV VAR USED DB_USER     : $DB_USER"
echo "ENV VAR USED DB_PASSWORD : $DB_PASSWORD"
echo "---------------------------- ------------------------"

CURRENT_PATH=`dirname "$0"`

StartMySQL ()
{
  echo "Starting MYSQL..."
  /etc/init.d/mysql stop
  /usr/bin/mysqld_safe > /dev/null 2>&1 &
  RET=1
  while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
  done
}

AllowFileSystemToMySQL ()
{

  MYSQL_DATA_DIR=$VOLUME_HOME/data
  MYSQL_LOG=$VOLUME_HOME/logs

  echo "Setting data directory to $MYSQL_DATA_DIR an logs to $MYSQL_LOG ..."
  if [[ ! -d $MYSQL_DATA_DIR ]] ; then
    echo "Creating DATA dir > $MYSQL_DATA_DIR ..."
    mkdir -p $MYSQL_DATA_DIR
    # mysql as owner and group owner
    chown -R mysql:mysql $MYSQL_DATA_DIR
  fi
  if [[ ! -d $MYSQL_LOG ]] ; then
    echo "Creating LOG dir > $MYSQL_LOG ..."
    mkdir -p $MYSQL_LOG
    # mysql as owner and group owner
    chown -R mysql:mysql $MYSQL_LOG
  fi

  # edit app mysql permission in : /etc/apparmor.d/usr.sbin.mysqld
  COUNT_LINE=`cat /etc/apparmor.d/usr.sbin.mysqld | wc -l`
  sed -i "$(($COUNT_LINE)) i $MYSQL_DATA_DIR/ r," /etc/apparmor.d/usr.sbin.mysqld
  sed -i "$(($COUNT_LINE)) i $MYSQL_DATA_DIR/** rwk," /etc/apparmor.d/usr.sbin.mysqld
  sed -i "$(($COUNT_LINE)) i $MYSQL_LOG/ r," /etc/apparmor.d/usr.sbin.mysqld
  sed -i "$(($COUNT_LINE)) i $MYSQL_LOG/** rwk," /etc/apparmor.d/usr.sbin.mysqld

  # reload app permission manager service
  service apparmor reload
}

UpdateMySQLConf()
{
  echo "Updating MySQL conf files [DATA, LOGS]..."
  sed -i "s:/var/lib/mysql:$MYSQL_DATA_DIR:g" /etc/mysql/my.cnf
  sed -i "s:/var/log/mysql/error.log:$MYSQL_LOG/error.log:g" /etc/mysql/my.cnf
  sed -i "s:3306:$PORT:g" /etc/mysql/my.cnf
  if [ ! -f /usr/share/mysql/my-default.cnf ] ; then
    cp /etc/mysql/my.cnf /usr/share/mysql/my-default.cnf
  fi
  if [ ! -f /etc/mysql/conf.d/mysqld_charset.cnf ] ; then
    cp $CURRENT_PATH/mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf
  fi

  if [ "$BIND_ADRESS" == "true" ]; then
    sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
  fi
}

InitMySQLDb() {

  # create database DB_NAME
  if [ "$DB_NAME" ]; then
    echo "INIT DATABASE $DB_NAME"
    mysql -u root -e "CREATE DATABASE $DB_NAME";
  fi

  # create user and give rights
  if [ "$DB_USER" ]; then
    echo "CREATE USER $DB_USER WITH PASSWORD $DB_PASSWORD AND GRAND RIGHTS ON $DB_NAME"
    mysql -uroot -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '$DB_PASSWORD'"
    mysql -uroot -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' WITH GRANT OPTION"
    mysql -uroot -e "FLUSH PRIVILEGES"
  fi

}

# Create a new database path to the attched volume
if [[ ! -d $VOLUME_HOME/data ]] ; then
  echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME/data"
  AllowFileSystemToMySQL
  UpdateMySQLConf
  echo "=> Init new database path to $MYSQL_DATA_DIR"
  mysql_install_db --basedir=/usr --datadir=$MYSQL_DATA_DIR
  echo "=> MySQL database initialized !"
else
  echo "=> Using an existing volume of MySQL"
  AllowFileSystemToMySQL
  UpdateMySQLConf
fi

# Finally start MySQL with new configuration
StartMySQL
InitMySQLDb

echo DB_NAME=\"$DB_NAME\" >> /tmp/mysql.conf
echo DB_USER=\"$DB_USER\" >> /tmp/mysql.conf
echo DB_PASSWORD=\"$DB_PASSWORD\" >> /tmp/mysql.conf
