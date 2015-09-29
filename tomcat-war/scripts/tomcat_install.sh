#!/bin/sh -e

currHostName=`hostname`

currFilename=$(basename "$0")

echo "${currHostName}:${currFilename} Tomcat url ${TOMCAT_URL}"

echo "${currHostName}:${currFilename} Tomcat port ${TOMCAT_PORT}"

echo "${currHostName}:${currFilename} Tomcat home ${TOMCAT_HOME}"

if [ -f /usr/bin/wget ]; then
	DOWNLOADER="wget"
elif [ -f /usr/bin/curl ]; then
	DOWNLOADER="curl"
fi

echo "${currHostName}:${currFilename} :DOWNLOADER ${DOWNLOADER}"

# args:
# $1 the error code of the last command (should be explicitly passed)
# $2 the message to print in case of an error
#
# an error message is printed and the script exists with the provided error code
error_exit () {
	echo "${currHostName}:${currFilename} $2 : error code: $1"
	exit $1
}

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
		Q_FLAG=""
		O_FLAG="-o"
		LINK_FLAG="-O"
	fi
	echo "${currHostName}:${currFilename} $DOWNLOADER $4 $Q_FLAG $O_FLAG $3 $LINK_FLAG $2"
	sudo $DOWNLOADER $Q_FLAG $O_FLAG $3 $LINK_FLAG $2 || error_exit $? "Failed downloading $1"
}

# create tomcat home if not exist
if [ ! -d "$TOMCAT_HOME" ]; then
    sudo mkdir -p $TOMCAT_HOME
fi

echo "${currHostName}:${currFilename} Downloading ${TOMCAT_URL} to ${destJavaArchive} ..."
download "Tomcat" $TOMCAT_URL $TOMCAT_HOME/tomcat_archive.tar.gz

# Install tomcat
sudo tar xzvf $TOMCAT_HOME/tomcat_archive.tar.gz --strip 1 -C $TOMCAT_HOME
sudo rm $TOMCAT_HOME/tomcat_archive.tar.gz

# removing default apps to speed up startup
sudo rm -rf $TOMCAT_HOME/webapps/docs
sudo rm -rf $TOMCAT_HOME/webapps/examples
#sudo rm -rf $TOMCAT_HOME/webapps/host-manager
#sudo rm -rf $TOMCAT_HOME/webapps/manager

# add the setenv.sh in bin
sudo touch $TOMCAT_HOME/bin/setenv.sh
sudo chmod 777 $TOMCAT_HOME/bin/setenv.sh
sudo echo "export CATALINA_OPTS=\"-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xms1024m -Xmx1024m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC\"" >> $TOMCAT_HOME/bin/setenv.sh

tomcatConfFolder=$TOMCAT_HOME/conf
serverXml=$tomcatConfFolder/server.xml

echo "${currHostName}:${currFilename} Configure tomcat to use port ${TOMCAT_PORT}"
sudo sed -i -e "s/port=\"8080\"/port=\"$TOMCAT_PORT\"/g" $serverXml
