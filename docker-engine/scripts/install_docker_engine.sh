#!/bin/bash -e

# Installs the docker-engine.
case $OS in
    "ubuntu")
        NAME="Docker Engine"
        LOCK="/tmp/lockaptget"

        while true; do
            if mkdir "${LOCK}" &>/dev/null; then
              echo "$NAME take apt lock"
              break;
            fi
            echo "$NAME waiting apt lock to be released..."
            sleep 0.5
        done

        while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
            echo "$NAME waiting for other software managers to finish..."
            sleep 0.5
        done
        sudo rm -f /var/lib/dpkg/lock

        sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
        linux_codename=$(lsb_release -cs)
        echo "deb https://apt.dockerproject.org/repo ubuntu-${linux_codename} main" | sudo tee -a /etc/apt/sources.list.d/docker.list >/dev/null
        sudo apt-get -y update || (sleep 15; sudo apt-get update || exit $1)
        sudo apt-get install -y linux-image-extra-$(uname -r)
        sudo apt-get install -y docker-engine

        rm -rf "${LOCK}"
        echo "$NAME released apt lock"
        ;;
    "centos")
        sudo tee /etc/yum.repos.d/docker.repo <<-EOF
        [dockerrepo]
        name=Docker Repository
        baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
        enabled=1
        gpgcheck=1
        gpgkey=https://yum.dockerproject.org/gpg
EOF
        # Install
        sudo yum -y install docker-engine
        ;;
      *)
        echo "${OS} is not supported ATM. Exiting..."
        exit 1
        ;;
esac
exit 0
