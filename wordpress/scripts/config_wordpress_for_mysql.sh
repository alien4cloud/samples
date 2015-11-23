#!/bin/bash -e
echo "Write the wp-config.php file"

file=$(sudo find / -name 'wp-config-sample.php')
folder=$(dirname $file)
eval "cd $folder"

sudo cp wp-config-sample.php wp-config.php
sudo sed -i 's/database_name_here/'$DB_NAME'/' wp-config.php
sudo sed -i 's/username_here/'$DB_USER'/' wp-config.php
sudo sed -i 's/password_here/'$DB_PASSWORD'/' wp-config.php
sudo sed -i 's/localhost/'$DB_IP:$DB_PORT'/' wp-config.php
