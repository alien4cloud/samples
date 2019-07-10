In this example, we  deploy :
* an apache and expose it via a clusterIP service
* an nginx and expose it with 2 nodePort services
* the nginx  has 2 config map configuration updating nginx.conf file and adding a file for the page of one of the exposed service
* Nginx is set as an Apache proxy

It is displayed in the index.html file by using postStart exec command in the container.

## What is tested

* Container into a Deployment
* NodePort Services that expose a container's endpoint
* Interconnect of 2 containers with a clusterIP  service and displaying the parameters and content displayed by the service
* Usage of confiMap to configure a container
* Fill 2 configMap files with  node property values
* postStart exec command of a container

## How to deploy

Deploy the topology, 
* set as input the port number of the service exposed by Nginx (default is set to 88). It must not be set to 80 which is the default port
* 2  NodePort service ports will appear in the Deployment Info page, 
* Test the application using the IP address of one of the nodes of the K8S cluster with the 2 services



## Expected result

When you test the url http://nodeIp:nodePort1 (DefaultPort) you should see :


![Welcome Page Apache !](images/welcomeApache.png)

When you test the url http://nodeIp:nodePort2 (CustomPort) you should see :
This is the welcome paged of added port <custom port set as input of the topology> NGINX 
The internal ipaddress (on clusterIP) of apache server is : <IP address assigned by K8S cluster>.
The internal port is : 80