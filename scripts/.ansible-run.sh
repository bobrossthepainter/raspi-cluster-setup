#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
            -u pi \
            -i /work/inventory \
            --become \
            $@
