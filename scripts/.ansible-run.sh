#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
            -u pi \
            --private-key=/work/.secrets/id_rsa \
            -i /work/target/inventory \
            --become \
            $@
