#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Set the path to your inventory file
INVENTORY_FILE=$DIR/../inventory

# Use awk to extract the host and user values and save them in arrays
ANSIBLE_HOST=($(grep -Eo 'ansible_host=[^ ]+' $INVENTORY_FILE | sed 's/ansible_host=//'))
ANSIBLE_USER=($(grep -Eo 'ansible_user=[^ ]+' $INVENTORY_FILE | sed 's/ansible_user=//'))



echo ${ANSIBLE_HOST[@]}
# Loop through the arrays and perform some action for each pair
for (( i=0; i<${#ANSIBLE_HOST[@]}; i++ )); do
    echo "Host: ${ANSIBLE_HOST[$i]}, User: ${ANSIBLE_USER[$i]}"
    ssh ${ANSIBLE_USER[$i]}@${ANSIBLE_HOST[$i]} "sudo shutdown -h now" &
    # Perform some action for each pair, such as running an Ansible command or script
done
