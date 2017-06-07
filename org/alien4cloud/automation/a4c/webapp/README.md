The TOSCA types in this service template are used to build an ALIEN topology with Higth Availability capabilities.

The HA, when managed by this plugin is a primary/backup mode with an election mecanism based on Consul: only one Alien node can be elected as a leader at a given time.

A typically HA topology could be:

- a Consul cluster of at least 3 consul agents in server mode.
- an ElasticSearch cluster of at least 2 nodes in replicated mode.
- an ALIEN cluster of at least 2 nodes with HA mode enabled.
- a reverse proxy: Nginx. Near this reverse proxy, we can use Consul-Template to automatically configure Nginx regarding changes in Consul.
- since ALIEN use local file system to store data (archives, plugins ...), we need a distributed (and eventually replicated or at least backuped) file system. We use a Samba server in order to make our ALIEN instances sharing the same file system.

