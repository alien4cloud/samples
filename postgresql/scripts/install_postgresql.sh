#!/bin/bash -x

echo "Centos based PostgreSQL install 9.2..."

NAME="PostgreSQL"
LOCK="/tmp/lockyum"

while true; do
  if mkdir "${LOCK}" &>/dev/null; then
    echo "$NAME take yum lock"
    break;
  fi
  echo "$NAME waiting yum lock to be released..."
  sleep 0.5
done


# TODO find yum lock file. Maybe actually yum just makes the waiting itself .... 
#while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
#  echo "$NAME waiting for other software managers to finish..."
#  sleep 0.5
#done

# http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm
sudo rpm -Uvh $REPOSITORY

#sudo yum -y update
sudo yum -y install ntp
sudo yum -y install postgresql95-server postgresql95

rm -rf "${LOCK}"
echo "$NAME released yum lock"

echo "PostgreSQL Installation complete."
