#!/bin/bash
APP_NAME=alien4cloud
PIDFILE=/var/run/${APP_NAME}.pid
ALIEN_PATH="/opt/alien4cloud/alien.war"
ALIEN_CONF="/etc/alien4cloud/"

JAVA_OPTIONS="-server -showversion -XX:+AggressiveOpts -Xmx1400m -Xms1400m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -Xloggc:/var/log/alien4cloud/gc.log"

case "$1" in
start)
  printf "%-50s" "Starting $APP_NAME ..."
  sudo bash -c "java $JAVA_OPTIONS -cp $ALIEN_CONF:$ALIEN_PATH org.springframework.boot.loader.WarLauncher ${APP_ARGS} > /var/log/alien4cloud/alien4cloud.out 2>&1 & echo \$! > ${PIDFILE}"
;;
status)
  printf "%-50s" "Checking $NAME..."
  if [ -f $PIDFILE ]; then
    PID=`cat $PIDFILE`
    if [ -z "`ps axf | grep ${PID} | grep -v grep`" ]; then
      printf "%s\n" "Process dead but pidfile exists"
    else
      echo "Running"
    fi
  else
    printf "%s\n" "Service not running"
  fi
;;
stop)
  printf "%-50s" "Stopping $NAME"
  PID=`cat $PIDFILE`
  if [ -f $PIDFILE ]; then
    kill -HUP $PID
    printf "%s\n" "Ok"
    rm -f $PIDFILE
  else
    printf "%s\n" "pidfile not found"
  fi
;;
restart)
  $0 stop
  $0 start
;;
*)
  echo "Usage: $0 {status|start|stop|restart}"
  exit 1
esac
