#!/usr/bin/env /opt/manager/env/bin/python

# Usage: sudo ./cfy_config_aws.py -c cfy_config_aws.yaml -u admin -p ad1min --ssl

import argparse
import yaml


from cloudify_rest_client import CloudifyClient
from ConfigParser import ConfigParser

BOTO_CONF_PATH = '/etc/cloudify/aws_plugin/boto'

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

    with open(path, 'w') as fh:
        config.write(fh)

    print "Created boto configuration at {}".format(path)


def update_manager_context_for_aws(manager_username,
                                   manager_password,
                                   manager_ssl,
                                   agent_pk_path='/root/.ssh/agent_key.pem',
                                   agent_user='ubuntu',
                                   agent_sg_id='secgroup_id',
                                   agent_kp_id='keypair_name'):

    client = CloudifyClient(
         username=manager_username,
         password=manager_password,
         trust_all=manager_ssl,
         tenant='default_tenant',
         host='localhost',
         port=(443 if manager_ssl else 80),
         protocol=('https' if manager_ssl else 'http')
    )

    name = client.manager.get_context()['name']
    context = client.manager.get_context()['context']
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

    client.manager.update_context(name, context)

    print "Updated manager's context"


def configure_manager(username, password, ssl, configuration_file=None):
    with open(configuration_file, 'r') as f:
        yaml_config = yaml.load(f)

    create_boto_config(path=BOTO_CONF_PATH,
                       aws_access_key_id=yaml_config['aws_access_key'],
                       aws_secret_access_key=yaml_config['aws_secret_key'],
                       region=yaml_config['aws_region'])

    update_manager_context_for_aws(
                       manager_username=username,
                       manager_password=password,
                       manager_ssl=ssl,
                       agent_kp_id=yaml_config['agent_keypair_name'],
                       agent_sg_id=yaml_config['agent_security_group_id'],
                       agent_user=yaml_config['agent_sh_user'],
                       agent_pk_path=yaml_config['agent_private_key_path'])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--config', type=str, required=True)
    parser.add_argument('-u', '--username', type=str, required=True)
    parser.add_argument('-p', '--password', type=str, required=True)
    parser.add_argument('--ssl', default=False, action='store_true')

    kwargs = parser.parse_args()

    configure_manager(kwargs.username,
                      kwargs.password,
                      kwargs.ssl,
                      kwargs.config)


if __name__ == "__main__":
    main()
