#/bin/sh
# In the current folder or in the $1 arg if passed:
# Search for all files named types.yml, build csar in the parent directory and upload to A4C if env defined.

upload() {
  if [ -z "$ALIEN_URL" -o -z "$ALIEN_LOGIN" -o -z "$ALIEN_PWD" ]; then
    echo "I need ALIEN_URL, ALIEN_LOGIN and ALIEN_PWD to be defined in order to upload $1 into A4C !"
    exit 0;
  fi
  echo "Upload $1 to $ALIEN_LOGIN:$ALIEN_PWD@$ALIEN_URL"

  curl -k -c .curlcookie "$ALIEN_URL/login?username=$ALIEN_LOGIN&password=$ALIEN_PWD&submit=Login" \
    -XPOST \
    -H 'Content-Type: application/x-www-form-urlencoded'
  curl -k -X POST -b .curlcookie -F file=@csar.zip "$ALIEN_URL/rest/latest/csars" 

  rm -f .curlcookie
}

build() {
  DIR=$(dirname $1)
  cd ${DIR}
  echo "Building CSAR in $(pwd)"
  if [ -d "playbook" ]; then
    echo "Zip playbook"
    cd playbook
    rm -f playbook.ansible
    zip -r playbook.ansible *
    cd ..;
  fi
  rm -f csar.zip
  echo "Zip csar"
  zip -r csar.zip *
  upload csar.zip
}

export -f upload
export -f build

FIND_FOLDER=.
if [ -n "$1" -a -d "$1" ]; then
  FIND_FOLDER="$1"
fi
echo "Searching csars in $FIND_FOLDER"

find "${FIND_FOLDER}" -name "types.yml" -exec bash -c "build {}" \;
# TODO something like this may be better but does'nt work :|
#for f in $(find . | xargs grep 'tosca_definitions_version' -sl); do build $f; done
