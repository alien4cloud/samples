#!/bin/bash -e

echo "Loading commons"

# Ensure that the last executed operation has been successfully executed, exit with error if not.
#
# args:
# $1 operation description (just for logs).
ensure_success() {
  if [ "$?" -ne 0 ]; then
    echo "The following operation failed ! Aborting : $1" >&2;
    exit 1;
  else
    echo "The following operation succeed: $1";
  fi
}

# Download the file using the available download command: wget or curl.
#
# args:
# $1 download description.
# $2 download link.
# $3 output file.
download() {
  echo "Will download $1 from $2 into $3"

  if [ -f /usr/bin/wget ]; then
    DOWNLOADER="wget"
  elif [ -f /usr/bin/curl ]; then
    DOWNLOADER="curl"
  fi

  if [ "$DOWNLOADER" = "wget" ];then
    Q_FLAG="--no-check-certificate -q"
    O_FLAG="-O"
    LINK_FLAG=""
  elif [ "$DOWNLOADER" = "curl" ];then
    Q_FLAG="-ks"
    O_FLAG="-Lo"
    LINK_FLAG="-O"
  else
    echo "Nor wget or curl is present, can't download anything, aborting !" >&2
    exit 1
  fi
  echo "Downloading using command: $DOWNLOADER $Q_FLAG $O_FLAG $3 $LINK_FLAG $2"
  sudo $DOWNLOADER $Q_FLAG $O_FLAG $3 $LINK_FLAG $2 >/dev/null 2>&1
  ensure_success "Downloading using command: $DOWNLOADER $Q_FLAG $O_FLAG $3 $LINK_FLAG $2"
}

# Try to guess the Operating System distribution
# The guessing algorithm is:
#   1- use lsb_release retrieve the distribution name (should normally be present it's listed as requirement of VM images in installation guide)
#   2- If lsb_release is not present check if yum is present. If yes assume that we are running Centos
#   3- Otherwise check if apt-get is present. If yes assume that we are running Ubuntu
#   4- Otherwise give-up and return "unknown"
#
# Any way the returned string is in lower case.
# This function prints the result to the std output so you should use the following form to retrieve it:
# os_dist="$(get_os_distribution)"
get_os_distribution () {
  rname="unknown"
  if  [[ "$(which lsb_release)" != "" ]]
    then
    rname=$(lsb_release -si | tr [:upper:] [:lower:])
  else
    if [[ "$(which yum)" != "" ]]
      then
      # assuming we are on Centos
      rname="centos"
    elif [[ "$(which apt-get)" != "" ]]
      then
      # assuming we are on Ubuntu
      rname="ubuntu"
    fi
  fi
  echo ${rname}
}

install_packages() {
  packages_to_install="$*"
  echo "Installing packages ${packages_to_install}"
  case "$(get_os_distribution)" in
    "ubuntu" | "debian" | "mint")
    LOCK="/tmp/lockaptget"

    while true; do
      if mkdir "${LOCK}" &>/dev/null; then
        echo "take apt lock"
        #echo "$$>${LOCK}/pid"
        break;
      fi
      echo "waiting apt lock to be released..."
      sleep 2
    done
    while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
      echo "$NAME waiting for other software managers to finish..."
      sleep 2
    done
    sudo apt-get -y update > /dev/null 2>&1
    sudo apt-get -y install ${packages_to_install} > /dev/null 2>&1
    rm -rf "${LOCK}"
    echo "released apt lock"
    ;;
    "centos" | "redhat" | "fedora")
    sudo yum install -y install ${packages_to_install}
    ;;
  esac
}

# Check that this env var is not empty (and fail if it's empty).
#
# args:
# $1 the env var name
require_env () {
  VAR_NAME=$1
  if [ ! "${!VAR_NAME}" ]; then
    echo "==========================================================" >&2
    echo "Required env var <$VAR_NAME> not found ! Aborting" >&2
    echo "==========================================================" >&2
    exit 1
  else
    echo "The value for required var <$VAR_NAME> is: ${!VAR_NAME}"
  fi
}

# Check that the csv list of env vars are not empty (fail if one is empty).
#
# args:
# $1 comma or space separated list of env variable names
require_envs () {
  VAR_LIST=$1
  for VAR_NAME in $(echo ${VAR_LIST} | tr ',' ' ')
  do
    require_env ${VAR_NAME}
  done
}

# Eval the config file and replace the listed env vars.
# Variables are expected to apear in mode %VAR_NAME% in source file.
# It will not work if VAR_NAME or VAR_VALUE contains '@' (but will if they contain '/' !)
#
# args:
# $1 the source file location
# $2 the destination file location
# $1 the list of environment variable to replace
eval_conf_file () {
  SRC_FILE=$1
  DEST_FILE=$2
  VAR_LIST=$3

  sudo cp $SRC_FILE $DEST_FILE
  if [ ! -z "$VAR_LIST" ]; then
    for VAR_NAME in $(echo ${VAR_LIST} | tr ',' ' ')
    do
      VAR_VALUE="${!VAR_NAME}"
      sudo sed -i -e "s@%${VAR_NAME}%@${VAR_VALUE}@g" $DEST_FILE
    done
  fi
  echo "Content of $DEST_FILE"
  sudo cat $DEST_FILE
}

# Ensure that the list of binaries are found on the system, fail if on is not found.
#
# args:
# $1 space separated list of binaries
require_bin () {
  BIN_LIST=$*
  for BIN_NAME in ${BIN_LIST};
  do
    if ! [ -x "$(command -v ${BIN_NAME})" ]; then
      echo "==========================================================" >&2
      echo "${BIN_NAME} is not installed." >&2
      echo "==========================================================" >&2
      exit 1
    else
      echo "${BIN_NAME} is installed"
    fi
  done
}

# Ensure that the list of dependency packages are found on the system,
# Install those that are not found using the right package manager (apt-get or yum).
#
# args:
# $1 space separated list of packages
install_dependencies() {
  PACKAGE_NAMES=$*
  PACKAGES_TO_INSTALL=""
  for BIN_NAME in ${PACKAGE_NAMES};
  do
    if ! [ -x "$(command -v ${BIN_NAME})" ]; then
      echo "${BIN_NAME} was not found, I will install it"
      PACKAGES_TO_INSTALL="${PACKAGES_TO_INSTALL} ${BIN_NAME}"
    else
      echo "${BIN_NAME} was found, will not install it"
    fi
  done
  if [ "${PACKAGES_TO_INSTALL}" ]; then
    echo "I finally will install: ${PACKAGES_TO_INSTALL}"
    install_packages ${PACKAGES_TO_INSTALL}
  else
    echo "Nothing to install so far !"
  fi
}

echo "commons loaded"
