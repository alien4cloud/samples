# Test the ability to connect a petclinic container to an a4c service matched to a MySQL database.

In this example, we deploy a container that :
* is a client of an a4c service
* start a tomcat server
* pulls petclinic war from a repository maven and deploy it on Tomcat

At startup, the container fetch the content of the concrete service endpoint and put it in its own index.html in order to serve it.

You need to configure a a4c service using the provided type **org.alien4cloud.doc.kube.kcontainers.51-Petclinic.mysql.nodes.MysqlDbService** with the parameters of a mySQL database that has already been deployed


Before deployment, the service will be matched, the container will have the environment variable for the service protocol, ip_address, port, instance database name, user and password to be able to query the MySQL database
