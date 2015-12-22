#!/bin/bash
PID_PATH=$1
ALIEN_PATH="/opt/alien4cloud/alien.war"
ALIEN_CONF="/etc/alien4cloud/"

JAVA_OPTIONS="-server -showversion -XX:+AggressiveOpts -Xmx2g -Xms2g -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError"

sudo bash -c "java $JAVA_OPTIONS -cp $ALIEN_CONF:$ALIEN_PATH org.springframework.boot.loader.WarLauncher > /var/log/alien4cloud/alien4cloud.out 2>&1 &" 2>&1 &

RETURN_CODE=$?
pid=$!
echo ${pid} > $PID_PATH
exit $RETURN_CODE
