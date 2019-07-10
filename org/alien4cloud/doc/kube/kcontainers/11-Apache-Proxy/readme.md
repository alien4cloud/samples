This topology  deploys 2 apache containers. Client one is displaying property data from server one

In this example, we  deploy :
* an apache and expose it via a clusterIP service
* an apache and expose it via a nodePort service
ing nginx.conf file and adding a file for the page of one of the exposed service


## What is tested

* Container into a Deployment
* NodePort Services that expose a container's endpoint
* Interconnect of 2 containers with a clusterIP  service and displaying its internal endpoint by the nodePort service
* postStart exec command of a container

## How to deploy

Deploy the topology, 

* A NodePort service ports will appear in the Deployment Info page, 
* Test the application using the IP address of one of the nodes of the K8S cluster with the  service



## Expected result

When you test the url http://nodeIp:nodePort (DefaultPort) you should see :

This is the Apache server URL http://<IP address assigned by K8S cluster>.:'80 <content of server_msg property> of ApacheServer node

