#!/bin/bash -e
echo "${NODE}.${duration} sleep: ${duration} sec"
/bin/sleep $duration
echo "Test input with all types of variables"
# simple property
echo "Comment with instanciated variables : ${comment}"

#complex DR 
#complex property. Will results into the json serialization of the property value
echo "MORECOMPLEX is ${MORECOMPLEX}"
 # nested properties
echo "NESTEDVAL1 is ${val1}"
echo "NESTEDVAL2 is ${val2}"
