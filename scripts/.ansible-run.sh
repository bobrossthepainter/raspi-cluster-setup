#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ADDITONAL_PARAMS=""
if [[ -n "${HOST}" ]]; then
    ADDITONAL_PARAMS="$ADDITONAL_PARAMS --limit $HOST"
fi

echo "Running ansible with additional params: $ADDITONAL_PARAMS"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
            -i /work/inventory \
            --become \
            $ADDITONAL_PARAMS $@



