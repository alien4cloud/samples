#!/bin/bash -e
echo "${NODE}.${duration} sleep: ${duration} sec"
/bin/sleep $duration
# simple property - comment property
echo "Comment with instanciated variables : ${comment}"
# simple property
echo "Nom variable complexe : ${complexTest}" 
#complex property. Will results into the json serialization of the property value
echo "COMPLEX is ${COMPLEX}"
 # nested properties
echo "NESTED is ${NESTED}"
 # first element of the array nested property "nested_array"
echo "NESTED_ARRAY_ELEMENT is ${NESTED_ARRAY_ELEMENT}"

 # nested property of the map nested property "nested_map"
echo "NESTED_MAP_ELEMENT is ${NESTED_MAP_ELEMENT}"
