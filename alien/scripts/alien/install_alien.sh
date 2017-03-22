#!/bin/bash -e

echo "Installing Alien4Cloud."

if [ -f /usr/bin/wget ]; then
	DOWNLOADER="wget"
elif [ -f /usr/bin/curl ]; then
	DOWNLOADER="curl"
fi

# args:
# $1 download description.
# $2 download link.
# $3 output file.
download () {
	echo "${currHostName}:${currFilename} Downloading $1 from $2 ..."
	if [ "$DOWNLOADER" = "wget" ];then
		Q_FLAG="--no-check-certificate"
		O_FLAG="-O"
		LINK_FLAG=""
	elif [ "$DOWNLOADER" = "curl" ];then
		Q_FLAG="-k"
		O_FLAG="-o"
		LINK_FLAG="-O"
	fi
	echo "${currHostName}:${currFilename} $DOWNLOADER $4 $Q_FLAG $O_FLAG $3 $LINK_FLAG $2"
	sudo $DOWNLOADER $Q_FLAG $O_FLAG $3 $LINK_FLAG $2 || error_exit $? "Failed downloading $1"
}

# create user
sudo useradd alien4cloud

# create log folder
if [ ! -d /var/log/alien4cloud ]; then
  sudo mkdir /var/log/alien4cloud
fi

# create application folder and copie files
if [ ! -d /opt/alien4cloud ]; then
  sudo mkdir /opt/alien4cloud
fi

echo "${currHostName}:${currFilename} Downloading ${APPLICATION_URL} to /opt/alien4cloud/alien.war ..."
download "Alien4cloud" $APPLICATION_URL /opt/alien4cloud/alien.war

# add configs
if [ ! -d /etc/alien4cloud ]; then
  sudo mkdir /etc/alien4cloud
fi
sudo cp -R -f $configs/* /etc/alien4cloud

# add the appropriate user
sudo chown -R alien4cloud:alien4cloud /var/log/alien4cloud
sudo chown -R alien4cloud:alien4cloud /opt/alien4cloud
sudo chown -R alien4cloud:alien4cloud /etc/alien4cloud

# add init script and start service

sudo bash -c "sed -e 's/\\\${APP_ARGS}/${APP_ARGS}/' $bin/alien.sh > /etc/init.d/alien"
sudo chmod +x /etc/init.d/alien

sudo update-rc.d alien defaults 95 10
