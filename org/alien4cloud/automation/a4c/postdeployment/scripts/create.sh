#!/bin/bash -e
APP_NAME=alien4cloud-postdeployment-webapp
ALIEN_PATH=${INSTALL_DIR}/${APP_NAME}.war
sudo mkdir -p $INSTALL_DIR
sudo mv ${bin} ${ALIEN_PATH}
