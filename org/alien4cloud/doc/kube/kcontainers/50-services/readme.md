# Test the ability to connect a container to an a4c service.

In this example, we deploy a container that :
* is a client of an a4c service
* start a nginx WebServer

At startup, the container fetch the content of the concrete service endpoint and put it in its own index.html in order to serve it.

You need to configure a a4c service using the provided type **org.alien4cloud.doc.kube.kcontainers.50-services.types.nodes.MyService** with these values :

```
properties:
  key: mykey
capabilities:
  protocol: http
  port: 80
  path: /wiki/Hello_world
attributes:
  capabilities.service_endpoint.ip_address: fr.wikipedia.org
```

Before deployment, the service will be matched, the container will have the environment variable for the service protocol, ip_address, port and path and will be able to fetch the content of the resulting url.
