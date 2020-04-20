#! /bin/sh

touch /work/.home/.bashrc
echo "alias k8s='ssh root@$K8S_HOST -p $SSH_HOST'" > /work/.home/.bashrc
echo "alias k8s-forward='ssh -4 root@$K8S_HOST -p $SSH_HOST -L 3000:127.0.0.1:3000'" > /work/.home/.bashrc

exec "$@"
