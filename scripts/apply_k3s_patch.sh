#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

cp $DIR/../src/ansible/k3s_patch/* $DIR/../src/k3s_setup -Rv