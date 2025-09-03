#!/bin/sh
# scripts/bootstrap.sh – maakt Incus containers klaar
set -eu

. $(dirname "$0")/settings.env

# Containers
for c in samba authentik forgejo woodpecker traefik; do
  incus launch images:debian/12 ${c}
  incus exec ${c} -- apt update
  incus exec ${c} -- apt install -y python3 python3-apt sudo
  incus config set ${c} security.nesting=true
  incus file push ~/.ssh/id_rsa.pub ${c}/root/.ssh/authorized_keys
  echo "Container ${c} klaar"
done
