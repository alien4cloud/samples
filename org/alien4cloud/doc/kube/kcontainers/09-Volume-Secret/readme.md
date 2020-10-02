In this example :
* In this example, we deploy an apache and expose it via a NodePort service.
* On same deployment we add a secret as it's `/usr/local/apache2/htdocs/index.html`, whose content is an artifact of secretVolume specified on the topology

As a result, the message written by the sidecar is viewable in the website.

## What is tested

* Container into a Deployment
* NodePort Service that expose a container's endpoint
* secretvolume created with pod


## How to deploy

Deploy the topology, the NodePort service port will appear in the Deployment Info page, test the application using the IP address of one of the nodes of the K8S cluster.

## Expected result

When you test the url http://nodeIp:nodePort you should see :
**This is Apache welcome as a Kubernetes secret**


