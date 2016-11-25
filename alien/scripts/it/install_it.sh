#!/bin/bash -e
sudo bash -c "echo '127.0.0.1 `hostname`' >> /etc/hosts"

sudo apt-get update
sudo apt-get -y install git maven npm ruby
sudo npm install -g bower
sudo npm -g install grunt-cli
sudo npm install grunt-contrib-compass --save-dev

sudo wget http://fastconnect.org/ssl/ServerCertificate.crt
export mvn_java=`mvn --version | grep "Java home" | cut -d':' -f2 | xargs`
sudo keytool -keystore ${mvn_java}/lib/security/cacerts -import -alias fastconnect -file ServerCertificate.crt -storepass changeit -noprompt

if [ ! -d /opt/alien4cloud ]; then
  sudo mkdir /opt/alien4cloud
fi
if [ ! -d /opt/alien4cloud/src ]; then
  sudo mkdir /opt/alien4cloud/src
fi
cd /opt/alien4cloud/src

# clone alien
sudo git clone -b ${BRANCH} https://github.com/alien4cloud/alien4cloud.git
# build alien
cd /opt/alien4cloud/src/alien4cloud
sudo mvn -fn clean install
cd /opt/alien4cloud/src/

# clone cloudify provider
sudo git clone -b ${BRANCH} https://github.com/alien4cloud/alien4cloud-cloudify3-provider.git
# build cloudify provider
cd /opt/alien4cloud/src/alien4cloud-cloudify3-provider
sudo mvn clean install -DskipTests
cd /opt/alien4cloud/src/

# clone provider tests
sudo git clone -b ${BRANCH} https://github.com/alien4cloud/alien4cloud-provider-int-test.git
# change suffs in alien4cloud-config.yml
cd /opt/alien4cloud/src/alien4cloud-provider-int-test
sudo sed -i -e 's/\(alien: \).*/alien: \/opt\/alien4cloud\/data/' src/test/resources/alien4cloud-config.yml
if [ -n "$MANAGER_NAME" ]; then
  sudo sed -i -e "s/\(manager_name: \).*/manager_name: ${MANAGER_NAME}/" src/test/resources/alien4cloud-config.yml
fi
# remove the Ignore tag
for file in `ls src/test/java/alien4cloud/it/*LongRun*.java`; do
  sudo sed -i -e "s/@Ignore//" $file
done

# use this log4j config
sudo cp -f $configs/log4j.properties src/test/resources/
sudo sed -i -e 's/alien4cloud\.log/alien4cloud-it.log/' src/test/resources/log4j.properties

sudo bash -c "echo 'version: ${PLUGIN_VERSION}' >> src/test/resources/version.yml"
# create log folder
if [ ! -d /var/log/alien4cloud ]; then
  sudo mkdir /var/log/alien4cloud
fi
