#!/bin/sh
# scripts/check-ansible.sh
set -eu
ansible -i ansible/inventories/hosts.yml all -m ping