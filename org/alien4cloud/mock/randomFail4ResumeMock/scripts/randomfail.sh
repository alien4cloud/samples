#!/bin/bash -e
randomcond=$(($RANDOM % 2))

if [ $randomcond = "1" ]
then
        echo "Salut 1 !"
fi

if [ $randomcond = "0" ]
then
        exit 1 
fi


