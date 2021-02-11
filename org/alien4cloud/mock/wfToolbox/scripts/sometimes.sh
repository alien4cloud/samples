#!/bin/bash -e

RND=$((RANDOM%100))

sleep ${duration}

if [ $RND -gt $CHANCE ]; then
	echo "SOMETIMES OPERATION SUCCESS [${RND}/${CHANCE}]"
	exit 0
else
	echo "SOMETIMES OPERATION FAILURE [${RND}/${CHANCE}]"
	exit 1
fi 
