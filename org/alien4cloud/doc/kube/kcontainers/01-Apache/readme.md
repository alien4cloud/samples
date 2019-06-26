In this example, we just deploy an apache and expose it via a NodePort services.

## What is tested

* Container into a deployement
* NodePort Service that expose a container's endpoint

## How to deploy

Deploy the topology, the NodePort service port will appear in the Deployment Info page, test the application using the IP address of one of the nodes of the K8S cluster.

## Expected result

When you test the url http://nodeIp:nodePort you should see :

![It works!](/images/itworks.png "It works!")
