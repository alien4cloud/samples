#!/bin/bash -e
echo "${NODE}.${duration} sleep: ${duration} sec"
/bin/sleep $duration

/bin/more ${data}

export ATT_HOSTNAME=$HOSTNAME
export ATT_DATE=$(date)
export ATT_SSH_CONNECTION=$SSH_CONNECTION
export ATT_CURRENT_PID=$$
export ATT_HOME=$ATT_HOME
export ATT_PWD=$(pwd)
export ATT_LOGNAME=$LOGNAME
export ATT_SSH_CLIENT=$SSH_CLIENT
export ATT_PPID=$PPID
