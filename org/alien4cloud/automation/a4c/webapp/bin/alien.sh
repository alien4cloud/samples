#!/bin/bash

APP_NAME=alien4cloud
#PIDFILE=/var/run/${APP_NAME}.pid
PROC=`ps -ef | grep -e alien4cloud* | grep -v grep | awk -F " " '{ print $2 }'`

JAVA_OPTIONS="-server -showversion -XX:+AggressiveOpts -Xmx1400m -Xms1400m -XX:MaxPermSize=512m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -Xloggc:/var/log/alien4cloud/gc.log"

case "$1" in
start)
  printf "%-50s\n" "Starting $APP_NAME ..."
  cd /opt/alien4cloud/alien4cloud/
  sudo bash -c "/opt/alien4cloud/alien4cloud/alien4cloud.sh ${APP_ARGS} >> /opt/alien4cloud/alien4cloud/logs/vm.out 2>&1 & echo \$!"
;;
status)
  if [[ $PROC ]]; then
    echo "$APP_NAME is running!"
  else
    echo "$APP_NAME is not Running"
  fi
;;
stop)
  printf "%-50s" "Stopping $APP_NAME"
  if [[ $PROC ]]; then
    sudo kill $PROC
    printf "%s\n" "Ok"
    #rm -f $PIDFILE
  else
   printf "Process is not running"
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
