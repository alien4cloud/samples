A topology to illustrate the behavior of nodes and their operations during workflow lifecycle.

Nodes and relationship operation are logged in a central registry and are viewable using a web browser. You can also explore the environment variables for each operation.

![Alien4Cloud](https://raw.githubusercontent.com/alien4cloud/samples/master/demo-lifecycle/img/lifecycle.png)

The topology contains:

- A ComputeRegistry that host a Apache + PHP + few PHP scripts that acts as a registry for others nodes.
- 2 other computes (ComputeA and ComputeB) host:
   - a RegistryConfigurer that is link to the Registry (actually just peek it's IP and put it in /etc/hosts)
   - A couple of GenericHost + Generic

The 2 Generics are connected together.

Once deployed, you follow the lin given by the topology output property Registry.url  

## Requirements

- apt-get
- wget
