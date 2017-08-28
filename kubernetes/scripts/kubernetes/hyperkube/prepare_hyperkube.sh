#!/bin/bash -x

# OFFLINE_IMAGES_MAPPING='{
#   "gcr.io/google_containers/kubernetes-dashboard-amd64:v1.1.0" : "172.31.32.67:6666/kubernetes-dashboard-amd64:v1.1.0",
#   "gcr.io/google_containers/hyperkube-amd64:v1.2.1" : "172.31.32.67:6666/hyperkube-amd64:v1.2.1",
#   "gcr.io/google_containers/pause:2.0" : "172.31.32.67:6666/hyperkube-amd64:v1.2.1"
# }'


if [ -z "$OFFLINE_IMAGES_MAPPING" ] ; then
  echo "No images to map"
else
  IMAGE_MAP=$(echo $OFFLINE_IMAGES_MAPPING | grep -E -o '"[^"]*"[^:]*:[^"]*"[^"]*"')
  IMAGE_MAP=${IMAGE_MAP//[[:blank:]]/}

  echo "Images to map: $IMAGE_MAP"

  for ENTRY_MAP in ${IMAGE_MAP[@]}
  do
    PUBLIC_IMAGE=$(echo $ENTRY_MAP | sed 's/"\([^"]*\)":"\([^"]*\)"/\1/')
    PRIVATE_IMAGE=$(echo $ENTRY_MAP | sed 's/"\([^"]*\)":"\([^"]*\)"/\2/')

    echo "> Pulling from $PRIVATE_IMAGE"
    sudo docker pull $PRIVATE_IMAGE
    echo "> Tag image $PRIVATE_IMAGE to $PUBLIC_IMAGE"
    sudo docker tag $PRIVATE_IMAGE $PUBLIC_IMAGE
  done
fi
