#!/bin/bash

FILE=/tmp/$TOSCA_JOB_ID

if [ -f "$FILE" ]; then
        num=$(<"$FILE")
        num=$(( num+1 ))
else
        num=1
        echo "1" > $FILE
fi
echo $num > $FILE

if (( num >= 10 )); then
        echo "Done"
        rm $FILE
		export TOSCA_JOB_STATUS="FAILED"
else
        echo "Wait (id=$TOSCA_JOB_ID count=$num)"
        export TOSCA_JOB_STATUS="RUNNING"
fi

