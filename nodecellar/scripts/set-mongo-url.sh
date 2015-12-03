#!/bin/bash


echo "BEGIN set mongo url"

echo "export DB_PORT=$DB_PORT into ~/.bashrc"
echo "export DB_IP=$DB_IP into ~/.bashrc"
echo "export NODECELLAR_PORT=8088 >> ~/.bashrc"

sudo echo "#!/bin/bash" > ~/nodecellar_env.sh
sudo echo "export NODECELLAR_PORT=$NODECELLAR_PORT" >> ~/nodecellar_env.sh
sudo echo "export MONGO_HOST=$DB_IP" >> ~/nodecellar_env.sh
sudo echo "export MONGO_PORT=$DB_PORT" >> ~/nodecellar_env.sh

echo "END set mongo url"

