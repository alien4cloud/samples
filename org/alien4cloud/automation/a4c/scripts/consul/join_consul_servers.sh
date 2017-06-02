#!/bin/bash -e

number_of_instances=$(echo ${INSTANCES} | tr ',' ' ' | wc -w)
if [ "${number_of_instances}" -gt "1" ]; then
	IFS=',';
	CONSUL_SERVER_ADDRESSES=""
	for i in $INSTANCES;
	do
		varname="${i}_CONSUL_ADDRESS";
		if [ "${i}" != "${INSTANCE}" ]; then
			CONSUL_SERVER_ADDRESSES="${!varname}"
		fi
	done
	echo "Joining cluster by contacting following member ${CONSUL_SERVER_ADDRESSES}"
	sudo consul join ${CONSUL_SERVER_ADDRESSES}
	echo "Consul has following members until now"
	sudo consul members
else
	echo "The cluster has only 1 member, don't join it ..."
fi
