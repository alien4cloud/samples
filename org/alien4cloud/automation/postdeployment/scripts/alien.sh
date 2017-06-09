#!/bin/bash -e
APP_NAME=alien4cloud-postdeployment-webapp
ALIEN_PATH=${INSTALL_DIR}/${APP_NAME}.war
PIDFILE=/var/run/${APP_NAME}.pid

if [ ! -f $ALIEN_PATH ]; then
  echo "No file found at ${ALIEN_PATH}!"
  exit 1
fi
if [ ! -f /var/log/alien4cloud/$APP_NAME.out ]; then
  sudo mkdir -p /var/log/alien4cloud
fi
JAVA_OPTIONS="-server -showversion -XX:+AggressiveOpts -Xmx1400m -Xms1400m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+HeapDumpOnOutOfMemoryError -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -Xloggc:/var/log/$APP_NAME/gc.log"

if [ -z ${var+x} ]; then echo "var is unset"; else echo "var is set to '$var'"; fi

if [[ $# -eq 1 ]] ; then
  CMD=${1}
fi

case "${CMD}" in
start)
  printf "%-50s" "Starting $APP_NAME ..."
  sudo bash -c "nohup java $JAVA_OPTIONS -jar $ALIEN_PATH > /var/log/alien4cloud/$APP_NAME.out 2>&1 & echo \$! > ${PIDFILE}"
  sleep 10
;;
status)
  printf "%-50s" "Checking $APP_NAME..."
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
  printf "%-50s" "Stopping $APP_NAME"
  PID=`cat $PIDFILE`
  if [ -f $PIDFILE ]; then
    sudo kill -HUP $PID
    printf "%s\n" "Ok"
    sudo rm -f $PIDFILE
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
