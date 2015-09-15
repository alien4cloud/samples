#!/bin/sh -e

currHostName=`hostname`
currFilename=$(basename "$0")

echo "${currHostName}:${currFilename} Stopping Tomcat in ${TOMCAT_HOME}..."

echo "${currHostName}:${currFilename} Java home ${JAVA_HOME}"

# args:
# $1 the error code of the last command (should be explicitly passed)
# $2 the message to print in case of an error
#
# an error message is printed and the script exists with the provided error code
error_exit() {
	echo "$2 : error code: $1"
	exit ${1}
}

if [ -z "$JAVA_HOME" ]; then
    export PATH=$PATH:/usr/sbin:/sbin:$JAVA_HOME/bin || error_exit $? "Failed on: export PATH=$PATH:/usr/sbin:/sbin:$JAVA_HOME/bin"
else
    export PATH=$PATH:/usr/sbin:/sbin || error_exit $? "Failed on: export PATH=$PATH:/usr/sbin:/sbin"
fi

export CLASSPATH=

sudo $TOMCAT_HOME/bin/catalina.sh stop
echo "${currHostName}:${currFilename} Sucessfully stopped tomcat"