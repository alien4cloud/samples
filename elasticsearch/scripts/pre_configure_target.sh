#!/bin/bash -e
sudo sed -i -e "s/discovery\.zen\.ping\.unicast\.hosts\: \[\(.*\)\]/discovery\.zen\.ping\.unicast\.hosts\: \[\1, \"$ES_IP\"\]/g" /etc/elasticsearch/elasticsearch.yml
export i=`cat /etc/elasticsearch/elasticsearch.yml | grep index.number_of_replicas | grep -v "#" | cut -d":" -f2 | xargs`
export j=$((10#$i + 1))
sudo sed -i -e "s/index\.number_of_replicas\: $i/index\.number_of_replicas\: $j/g" /etc/elasticsearch/elasticsearch.yml
