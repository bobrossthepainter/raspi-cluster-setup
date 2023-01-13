#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

mkdir -p $DIR/../tmp/kube
scp pi@pi-btc:/home/pi/.kube/config $DIR/../tmp/kube/config
echo "Ranaming context..."
sed -i 's/default/muc-cluster/' $DIR/../tmp/kube/config
KUBECONFIG=$DIR/../tmp/kube/config kubectl config get-contexts
KUBECONFIG=$DIR/../tmp/kube/config kubectl config set clusters.muc-cluster.server https://${VIP_IP}:6443

echo "Merging kube config..."
cp ~/.kube/config ~/.kube/config.bak && KUBECONFIG=$DIR/../tmp/kube/config:~/.kube/config kubectl config view --flatten > /tmp/config && mv /tmp/config ~/.kube/config