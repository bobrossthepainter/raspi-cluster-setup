#! /bin/bash

KVVERSION=v0.5.7
INTERFACE=eth0
VIP=192.168.178.250

docker run --rm ghcr.io/kube-vip/kube-vip:$KVVERSION \
    manifest daemonset \
    --interface $INTERFACE \
    --address $VIP \
    --inCluster \
    --taint \
    --controlplane \
    --services \
    --arp \
    --leaderElection