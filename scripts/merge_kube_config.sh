#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

mkdir -p $DIR/../tmp/kube
scp pi@pi-btc:/home/pi/.kube/config $DIR/../tmp/kube/config
echo "Ranaming context..."
KUBECONFIG=$DIR/../tmp/kube/config kubectl config get-contexts
KUBECONFIG=$DIR/../tmp/kube/config kubectl config rename-context default muc-cluster

# echo "Merging kube config..."
# cp ~/.kube/config ~/.kube/config.bak && KUBECONFIG=~/.kube/config:$DIR/../tmp/kube/config kubectl config view --flatten > /tmp/config && mv /tmp/config ~/.kube/config