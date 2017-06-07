#!/bin/bash -e

# set the cluster name
sudo sed -i -e "s/cluster\.name\: \(.*\)$i/cluster\.name\: $CLUSTER_NAME/g" /etc/elasticsearch/elasticsearch.yml
# st the http port
sudo sed -i -e "s/http\.port\: \(.*\)$i/http\.port\: $HTTP_PORT/g" /etc/elasticsearch/elasticsearch.yml

# Count the number of replicas
number_of_replicas=$((0))
es_ips=""
for i in $(echo ${INSTANCES} | tr ',' ' ')
do
	varname="${i}_ES_IP"
	if [ "${i}" != "${INSTANCE}" ]; then
		echo "Detected another instance of ES with ip ${!varname}"
		if [ "${number_of_replicas}" -gt "0" ]; then
			es_ips="${es_ips}, "
		fi
		es_ips="${es_ips}\"${!varname}\""
		echo "List of replicas ips is now ${es_ips}"
		number_of_replicas=$((number_of_replicas + 1))
		echo "Number of replicas is now ${number_of_replicas}"
	fi
done

echo "List of replicas ips is finally ${es_ips}"
echo "Number of replicas is finally ${number_of_replicas}"

# Set the hosts if we have replicas
if [ "$number_of_replicas" -gt "0" ]; then
	sudo sed -i -e "s/discovery\.zen\.ping\.unicast\.hosts\: \[\(.*\)\]/discovery\.zen\.ping\.unicast\.hosts\: \[\1, $es_ips\]/g" /etc/elasticsearch/elasticsearch.yml
fi

# Set the number of replicas
export i=`cat /etc/elasticsearch/elasticsearch.yml | grep index.number_of_replicas | grep -v "#" | cut -d":" -f2 | xargs`
# TODO: add i + number_of_replicas
sudo sed -i -e "s/index\.number_of_replicas\: $i/index\.number_of_replicas\: $number_of_replicas/g" /etc/elasticsearch/elasticsearch.yml
