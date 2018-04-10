#!/usr/bin/env

# Usage:
# sudo ./cfy_configure_iaas.py -u admin -p ad1min --ssl config -c cfy_config_aws.yaml -i aws

import argparse
import grp
import json
import os
import pwd
import yaml

from cloudify_rest_client import CloudifyClient
from ConfigParser import ConfigParser

try:
    # Remove the ssl warning message
    import requests
    from requests.packages.urllib3.exceptions import InsecureRequestWarning
    requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
except:
    pass

BOTO_CONF_PATH = '/etc/cloudify/aws_plugin/boto'
AZURE_CONF_PATH = '/opt/cloudify_azure_provider.conf'
OPENSTACK_CONF_PATH = '/etc/cloudify/openstack_plugin/openstack_config.json'

OPENSTACK_RESOURCES_KEYS = {'agents_keypair', 'agents_security_group', 'ext_network',
                            'floating_ip', 'int_network', 'management_keypair',
                            'management_security_group', 'router', 'subnet'}

OPENSTACK_RESOURCES_TYPES = {'agents_keypair': 'keypair',
                             'agents_security_group': 'security_group',
                             'ext_network': 'network',
                             'floating_ip': 'floatingip',
                             'int_network': 'network',
                             'management_keypair': 'keypair',
                             'management_security_group': 'security_group',
                             'router': 'router',
                             'subnet': 'subnet'}

UID = pwd.getpwnam("cfyuser").pw_uid
GID = grp.getgrnam("cfyuser").gr_gid

def configure_manager(cfy_client, iaas, configuration_file=None):
    with open(configuration_file, 'r') as f:
        yaml_config = yaml.load(f)

    configure = {
        'aws': configure_aws,
        'azure': configure_azure,
        'openstack': configure_openstack
    }

    configure[iaas](cfy_client, yaml_config)


def configure_azure(cfy_client, yaml_config):
    create_azure_config(path=AZURE_CONF_PATH,
                        subscription_id=yaml_config['subscription_id'],
                        tenant_id=yaml_config['tenant_id'],
                        client_id=yaml_config['client_id'],
                        client_secret=yaml_config['client_secret'],
                        location=yaml_config['location'])

    update_manager_context_for_azure(
                       cfy_client=cfy_client,
                       agent_user=yaml_config['agent_sh_user'],
                       agent_pk_path=yaml_config['agent_private_key_path'])


def create_azure_config(path,
                        subscription_id,
                        tenant_id,
                        client_id,
                        client_secret,
                        location):
    config = ConfigParser()

    config.add_section('Credentials')
    config.set('Credentials',
               'subscription_id',
               subscription_id)
    config.set('Credentials', 'tenant_id', tenant_id)
    config.set('Credentials', 'client_id', client_id)
    config.set('Credentials', 'client_secret', client_secret)

    config.add_section('Azure')
    config.set('Azure', 'location', location)

    directory = os.path.dirname(path)
    if not os.path.exists(directory):
        os.makedirs(directory)

    with open(path, 'w+') as fh:
        config.write(fh)

    os.chown(path, UID, GID)
    print "Created Azure configuration at {}".format(path)


def update_manager_context_for_azure(cfy_client,
                                     agent_pk_path='/root/.ssh/agent_key.pem',
                                     agent_user='ubuntu'):

    name = cfy_client.manager.get_context()['name']
    context = cfy_client.manager.get_context()['context']
    context['cloudify']['cloudify_agent']['agent_key_path'] = agent_pk_path
    context['cloudify']['cloudify_agent']['user'] = agent_user

    agent_env = context['cloudify']['cloudify_agent'].get('env', {})
    agent_env['CFY_AZURE_CONFIG_PATH'] = AZURE_CONF_PATH
    context['cloudify']['cloudify_agent']['env'] = agent_env

    plugins = context['cloudify'].get('plugins', {})
    plugins['azure_config_path'] = AZURE_CONF_PATH
    context['cloudify']['plugins'] = plugins

    cfy_client.manager.update_context(name, context)

    print "Updated Azure manager's context"


def configure_aws(cfy_client, yaml_config):

    create_boto_config(path=BOTO_CONF_PATH,
                       aws_access_key_id=yaml_config['aws_access_key'],
                       aws_secret_access_key=yaml_config['aws_secret_key'],
                       region=yaml_config['aws_region'])

    update_manager_context_for_aws(
                       cfy_client=cfy_client,
                       agent_kp_id=yaml_config['agent_keypair_name'],
                       agent_sg_id=yaml_config['agent_security_group_id'],
                       agent_user=yaml_config['agent_sh_user'],
                       agent_pk_path=yaml_config['agent_private_key_path'])


def create_boto_config(path, aws_access_key_id, aws_secret_access_key, region):
    config = ConfigParser()

    config.add_section('Credentials')
    config.set('Credentials',
               'aws_access_key_id',
               aws_access_key_id)
    config.set('Credentials',
               'aws_secret_access_key',
               aws_secret_access_key)

    config.add_section('Boto')
    config.set('Boto', 'ec2_region_name', region)

    directory = os.path.dirname(path)
    if not os.path.exists(directory):
        os.makedirs(directory)

    with open(path, 'w+') as fh:
        config.write(fh)

    os.chown(path, UID, GID)
    print "Created boto configuration at {}".format(path)


def update_manager_context_for_aws(cfy_client,
                                   agent_pk_path='/root/.ssh/agent_key.pem',
                                   agent_user='ubuntu',
                                   agent_sg_id='secgroup_id',
                                   agent_kp_id='keypair_name'):

    name = cfy_client.manager.get_context()['name']
    context = cfy_client.manager.get_context()['context']
    context['cloudify']['cloudify_agent']['agent_key_path'] = agent_pk_path
    context['cloudify']['cloudify_agent']['user'] = agent_user

    agent_env = context['cloudify']['cloudify_agent'].get('env', {})
    agent_env['AWS_CONFIG_PATH'] = BOTO_CONF_PATH
    context['cloudify']['cloudify_agent']['env'] = agent_env

    resources = {
        'agents_security_group': {
            'external_resource': False,
            'id': agent_sg_id
        },
        'agents_keypair': {
            'external_resource': False,
            'id': agent_kp_id
        }
    }
    context['resources'] = resources

    cfy_client.manager.update_context(name, context)

    print "Updated AWS manager's context"


def configure_openstack(cfy_client, yaml_config):
    create_openstack_config(path=OPENSTACK_CONF_PATH,
                            auth_url=yaml_config['auth_url'],
                            tenant_name=yaml_config['tenant_name'],
                            username=yaml_config['username'],
                            password=yaml_config['password'],
                            region=yaml_config['region'])

    update_manager_context_for_openstack(
                       cfy_client=cfy_client,
                       agent_user=yaml_config['agent_sh_user'],
                       agent_pk_path=yaml_config['agent_private_key_path'],
                       resources_config=yaml_config['resources'])


def create_openstack_config(path,
                            auth_url,
                            tenant_name,
                            username,
                            password,
                            region):
    custom_configuration = {}
    custom_configuration['cinder_client'] = {'insecure': False}
    custom_configuration['keystone_client'] = {'insecure': False}
    custom_configuration['neutron_client'] = {'insecure': False}
    custom_configuration['nova_client'] = {'insecure': False}
    openstack_config = {}
    openstack_config['auth_url'] = auth_url
    openstack_config['tenant_name'] = tenant_name
    openstack_config['username'] = username
    openstack_config['password'] = password
    openstack_config['region'] = region
    openstack_config['custom_configuration'] = custom_configuration

    directory = os.path.dirname(path)
    if not os.path.exists(directory):
        os.makedirs(directory)

    with open(path, 'w+') as fh:
        json.dump(openstack_config, fh)

    os.chown(path, UID, GID)
    print "Created Openstack configuration at {}".format(path)


def update_manager_context_for_openstack(cfy_client,
                                         agent_pk_path='/root/.ssh/agent_key.pem',
                                         agent_user='ubuntu',
                                         resources_config={}):

    name = cfy_client.manager.get_context()['name']
    context = cfy_client.manager.get_context()['context']
    context['cloudify']['cloudify_agent']['key'] = agent_pk_path
    # context['cloudify']['cloudify_agent']['agent_key_path'] = agent_pk_path
    context['cloudify']['cloudify_agent']['user'] = agent_user

    # add openstack config
    agent_env = context['cloudify']['cloudify_agent'].get('env', {})
    agent_env['OPENSTACK_CONFIG_PATH'] = OPENSTACK_CONF_PATH
    context['cloudify']['cloudify_agent']['env'] = agent_env

    # add openstack config for plugins
    plugins = context['cloudify'].get('plugins', {})
    plugins['openstack_config_path'] = OPENSTACK_CONF_PATH
    context['cloudify']['plugins'] = plugins

    # add openstack resources informations
    resources = context['cloudify'].get('resources', {})

    for key in OPENSTACK_RESOURCES_KEYS:
        if key in resources_config:
            resources[key] = resources_config[key]
            resources[key]['type'] = OPENSTACK_RESOURCES_TYPES[key]
    context['resources'] = resources

    cfy_client.manager.update_context(name, context)

    print "Updated Openstack manager's context"


def print_agent_env(cfy_client):
    context = cfy_client.manager.get_context()['context']
    # Remove manager_deployment, which value is not readable by human
    del context['cloudify']['manager_deployment']
    print yaml.safe_dump(context, encoding='utf-8')


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('-u', '--username', type=str, required=True)
    parser.add_argument('-p', '--password', type=str, required=True)
    parser.add_argument('--ssl', default=False, action='store_true')

    subparsers = parser.add_subparsers()
    config_parser = subparsers.add_parser('config')
    config_parser.add_argument('-c', '--config', type=str, required=True)
    config_parser.add_argument('-i',
                               '--iaas',
                               type=str,
                               required=True,
                               choices=['aws', 'azure', 'openstack'])

    debug_parser = subparsers.add_parser('debug')
    debug_parser.add_argument('--print-agent-env',
                              default=True,
                              action='store_true')

    kwargs = parser.parse_args()

    cfy_client = CloudifyClient(
        username=kwargs.username,
        password=kwargs.password,
        trust_all=kwargs.ssl,
        tenant='default_tenant',
        host='localhost',
        port=(443 if kwargs.ssl else 80),
        protocol=('https' if kwargs.ssl else 'http')
    )

    if 'print_agent_env' in kwargs:
        print_agent_env(cfy_client)
    else:
        configure_manager(cfy_client,
                          kwargs.iaas,
                          kwargs.config)


if __name__ == "__main__":
    main()
