#!/bin/bash -e
APP_NAME=alien4cloud-postdeployment-webapp
ALIEN_PATH=${INSTALL_DIR}/${APP_NAME}.war
sudo mkdir -p $INSTALL_DIR

if [[ -z "${DOWNLOAD_USER// }" ]]; then
  echo "Downloading patch web app from $DOWNLOAD_URL to $ALIEN_PATH..."
  sudo curl -o $ALIEN_PATH -L $DOWNLOAD_URL
else
  echo "Downloading patch web app from $DOWNLOAD_URL with user $DOWNLOAD_USER to $ALIEN_PATH..."
  sudo curl -u $DOWNLOAD_USER:$DOWNLOAD_PASSWORD -o $ALIEN_PATH -L $DOWNLOAD_URL
fi
