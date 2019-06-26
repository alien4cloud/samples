In this example, we deploy an apache and expose it via a NodePort services.
A volume of type HostPath is attached to the container and `/var/log` from the host node is mounted at `/usr/local/apache2/htdocs` so we can access logs from web browser.

## What is tested

* Container into a Deployment
* NodePort Service that expose a container's endpoint
* hostPath volume mounted by a container

## How to deploy

Deploy the topology, the NodePort service port will appear in the Deployment Info page, test the application using the IP address of one of the nodes of the K8S cluster.

## Expected result

When you test the url http://nodeIp:nodePort you should see something like this (content of the K8S node's /var/log) :

![hostPath.png](images/hostPath.png)
