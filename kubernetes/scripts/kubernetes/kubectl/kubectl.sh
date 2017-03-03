#!/bin/bash

if [ -z "$KUBECTL_VERSION" ] ; then
  KUBECTL_VERSION=1.5.3
fi

KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
curl -L $KUBECTL_URL -o /tmp/kubectl
chmod +x /tmp/kubectl
sudo mv /tmp/kubectl /usr/local/bin/kubectl