#!/usr/bin/env

# Usage:
# sudo ./cfy_configure_iaas.py -u admin -p ad1min --ssl config -c cfy_config_aws.yaml -i aws

import argparse
import yaml
import os
from itsdangerous import base64_encode

from cloudify_rest_client import CloudifyClient
from ConfigParser import ConfigParser

BOTO_CONF_PATH = '/etc/cloudify/aws_plugin/boto'
AZURE_CONF_PATH = '/opt/cloudify_azure_provider.conf'


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
    print "[Configure openstack] yaml_config={}".format(yaml_config)


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

    headers = {'Authorization': 'Basic ' + base64_encode('{user}:{password}'.format(user=kwargs.username,password=kwargs.password))}
    cfy_client = CloudifyClient(host='localhost', port=443, protocol='https', headers=headers, trust_all=True)

    if 'print_agent_env' in kwargs:
        print_agent_env(cfy_client)
    else:
        configure_manager(cfy_client,
                          kwargs.iaas,
                          kwargs.config)


if __name__ == "__main__":
    main()

