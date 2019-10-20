#!/bin/bash -e

my_var=$(set)
echo "display of set command return"
echo $my_var
echo "display of apache url and curl of it"
echo ${APACHE_URL}
curl ${APACHE_URL}