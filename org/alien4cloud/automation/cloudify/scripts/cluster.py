# Python script to configure cloudify cluster
import time
import os
import socket
from cloudify_rest_client import CloudifyClient
from base64 import standard_b64encode

def waitPortOpen(ip, port):
    isClosed = True
    while isClosed:
        time.sleep(1)
        print "Waiting for port " + str(port) + " to be openend on " + ip
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex((ip, port))
        isClosed = result != 0

instancesStr = os.environ.get('INSTANCES')
instanceIds = sorted(instancesStr.split(","))

ip_address = os.environ.get('PUBLIC_IP')
adminUsername = os.environ.get('ADMIN_USERNAME')
adminPassword = os.environ.get('ADMIN_PASSWORD')

client = CloudifyClient(
    host=ip_address,
    port=443,
    protocol='https',
    trust_all=True,
    username=adminUsername,
    password=adminPassword,
    tenant='default_tenant')

current_instance = os.environ.get('INSTANCE')

if current_instance == instanceIds[0]:
    print "Trigger cluster initialization"
    # Starting the cluster
    client.cluster.start(
        host_ip=ip_address,
        node_name=current_instance
    )
    print "Letting cluster bootstrap run in background"

else:
    # Wait for cluster initial node to have cluster mode enabled
    print "Waiting cluster master node to be started"
    clusterMasterIp = os.environ.get(instanceIds[0] + '_PUBLIC_IP')
    waitPortOpen(clusterMasterIp, 8300)
    waitPortOpen(clusterMasterIp, 8301)
    waitPortOpen(clusterMasterIp, 15432)
    waitPortOpen(clusterMasterIp, 22000)
    waitPortOpen(clusterMasterIp, 8500)
    print "Cluster master is started, join the cluster"

    print "Connecting to master rest api"
    masterClient = CloudifyClient(
        host=clusterMasterIp,
        port=443,
        protocol='https',
        trust_all=True,
        username=adminUsername,
        password=adminPassword,
        tenant='default_tenant')

    print "Requesting node addition"
    credentials = masterClient.cluster.nodes.add(host_ip=ip_address, node_name=current_instance).credentials

    print "Joining cluster"
    # Join the cluster
    client.cluster.join(
        host_ip=ip_address,
        node_name=current_instance,
        credentials=credentials,
        join_addrs=[clusterMasterIp]
    )
