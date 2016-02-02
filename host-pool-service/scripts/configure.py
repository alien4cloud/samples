import os
import json
import shutil
import sys

def write_host_pool_config_file(pool_config_path, config_path):
    config_json = {
        'pool': pool_config_path
    }
    print 'Creating service configuration file'
    with open(config_path, 'w') as f:
        json.dump(config_json, f, indent=2)

def main(argv):

    work_directory = argv[1]
    config_folder_name = os.path.basename(argv[2]).split('.')[0]
    pool_file_name = argv[3]
    config_path = os.path.join(work_directory, 'config.json')
    pool_config_path = os.path.join(work_directory, config_folder_name, pool_file_name)
    write_host_pool_config_file(pool_config_path, config_path)

if __name__ == '__main__':
    main(sys.argv)
