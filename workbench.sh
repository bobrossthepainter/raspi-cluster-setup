#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Load configuration
if [[ ! -f "$DIR/.config" ]]; then
  echo "Using '.config.sample' as '.config' - Please validate '.config' file..."
  cp $DIR/.config.sample $DIR/.config
  . $DIR/.config
fi

echo "Loading '.config'..."
. $DIR/.config

# Init git-crypt encryption key if necessary
if [[ -f "$DIR/.encryption" ]]; then
  echo "Loading encryption key..."
	. $DIR/.encryption
fi

if [[ -z ${SECRET+x} ]]; then
	echo "No encryption key provided."
	echo "Creating new one..."
	git-crypt init
  KEY=$(cat "$DIR/.git/git-crypt/keys/default" | base64 -w 0)
  echo "SECRET=$KEY" >> $DIR/.encryption
fi

if [[ ! -f "$DIR/.git/git-crypt/keys/default" ]]; then
  echo "$SECRET" | base64 -d > $DIR/tmp.key
  git-crypt unlock $DIR/tmp.key
  rm $DIR/tmp.key
fi

if [[ ! -f "$DIR/.secrets/id_rsa" ]]; then
	echo "Creating rsa-keypair for communication with raspberries in '.secrets/'..."
	mkdir -p $DIR/.secrets
  ssh-keygen -t rsa -b 4096 -N "" -f $DIR/.secrets/id_rsa -q
fi

# Initialize virtual home directory for container
mkdir -p $DIR/.home

echo "Copying ssh-key to virtual '.home' directory..."
mkdir -p $DIR/.home/.ssh
cp $DIR/.secrets/id_rsa $DIR/.home/.ssh/id_rsa
cp $DIR/.secrets/id_rsa.pub $DIR/.home/.ssh/id_rsa.pub

# check inventory
if [[ ! -f "$DIR/inventory" ]]; then
	echo "Creating default inventory - Please validate 'inventory' file..."
  cp $DIR/.inventory.sample $DIR/.inventory
fi

echo "Building workbench image. This may take a while..."
IMG=$(docker build ./.workbench \
    --quiet \
    --build-arg KUBECTL_VERSION="$KUBECTL_VERSION" \
    --build-arg HELM_VERSION="$HELM_VERSION" \
    --network host )

docker run --rm \
    -v $DIR:/work \
    -v $DIR/.home:$DOCKER_HOME_DIR \
    -v $HOME/.kube:$DOCKER_HOME_DIR/.kube \
    -e SECRETS_KEY="$SECRETS_KEY" \
    -e PI_LOGIN="$PI_LOGIN" \
    -e PI_PASSWORD="$PI_PASSWORD" \
    -e K8S_HOST="$K8S_HOST" \
    -e SSH_HOST="$SSH_HOST" \
    -e K3S_VERSION="$K3S_VERSION" \
    -e RASPBIAN_VERSION="$RASPBIAN_VERSION" \
    -e RASPBIAN_IMAGE_LOCATION="$RASPBIAN_IMAGE_LOCATION" \
    -e ANSIBLE_HOST_KEY_CHECKING="False" \
    -e ANSIBLE_SSH_ARGS="-o ControlMaster=auto -o ControlPersist=60s -o userknownhostsfile=/dev/null" \
    -w /work \
    -it $IMG \
    bash --rcfile /.bashrc
