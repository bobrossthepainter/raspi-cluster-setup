## Introduction
There are 3 ansible playbooks within this repo which all-together setup a raspberry k3s-cluster. 
It is intended, that the raspberry is prepared with the raspbian os on a micro-sd and an external 
hard drive (referenced as ssd) is attached to the raspi by usb. 

The first playbook will setup raspbian on the ssd drive and do some system setup, like setting up 
automatic apt update jobs, deactivating gfx, wifi and other things on the raspi (feel free to take your picks here).

The second playbook installs k3s on the raspberries and is actually being cloned from the _rancher/k3s_ repo 
[ansible-k3s](https://github.com/rancher/k3s/tree/master/contrib/ansible).

The last one initialises the k3s-cluster with flux-cd as gitops tool. 

Thanks to the raspbernetes group for providing multi-arch images -> https://github.com/raspbernetes/multi-arch-images

Playbooks:
* node_setup
* k3s-ansible
* k3s-init

## Prerequisites
* The repo uses git-crypt, make sure to have it installed on your machine (e.a. apt-get install git-crypt)
* Docker
* Copy/rename `.config.example` file to `.config` and adjust to your needs
* Copy/rename `.inventory.example` file to `.inventory` and adjust to your infra-setup
    * The `usb_quirks=152d:1561` part in the inventory is handling the issue with some sata usb-controllers [LINK](https://www.raspberrypi.org/forums/viewtopic.php?t=245931). 
    You can leave the variable out, if your used controller doesn't have a problem here.

## Setup
There has been a Docker workbench prepared which provides all the necessary tools in order to execute the ansible 
playbooks. Besides starting the docker container, the `workbench.sh` script initialises essential parts in your 
working directory.

Enter the workbench `./workbench.sh` and then execute:
* `scripts/copy-key-to-pies` -> copies the generated pub-key to the pis, in order for ansible to work
* `scripts/gather-deps` -> clones the k3s-ansible playbook
* `scripts/compile` -> moves all the playbooks in the `target/` folder, applies some patch to k3s-ansible
* `scripts/ansible-node-setup` -> playbook 1
* `scripts/ansible-k3s` -> playbook 2
* `scripts/ansible-k3s-init` -> playbook 3