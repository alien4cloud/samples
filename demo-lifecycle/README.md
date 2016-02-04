A topology to illustrate the behavior of nodes and their operations during workflow lifecycle.

Nodes and relationship operation are logged in a central registry and are viewable using a web browser. You can also explore the environment variables for each operation.

![Alien4Cloud](https://raw.githubusercontent.com/alien4cloud/samples/master/demo-lifecycle/img/lifecycle.png)

The topology contains:

- A ComputeRegistry that host a Apache + PHP + few PHP scripts that acts as a **Registry** for others nodes.
- 2 other computes (ComputeA and ComputeB) host:
   - a **RegistryConfigurer** that is linked to the Registry (actually just peek it's IP and put it in /etc/hosts)
   - A couple of **GenericHost** + **Generic**

About components:

- **Generic** is hosted on **GenericHost**
- **GenericHost** as input on *configure* operation
- The 2 **Generic**s are connected together (with inputs on *add_source* and *add_target* operations)

Once deployed, just follow the link given by the topology output property Registry.url  

## Requirements

- apt-get
- wget

## TODOs

- [ ] apache port attribute should be used by RegistryConfigurer, and Generic & GenericHost
- [ ] simple python scripts could be lighter than apache + php (but for the moment I am not able to get the request body when using HTTPServer and CGIHTTPRequestHandler)
- [ ] apache doc root should be used by Registry
