#!/bin/sh
# scripts/bootstrap.sh – maakt Incus containers klaar
set -eu

. $(dirname "$0")/settings.env

DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
RELEASE=$(lsb_release -cs)
FALLBACK="debian/trixie"

# Containers
for c in samba authentik forgejo woodpecker traefik; do
  echo "Launching container $c..."
  if ! incus launch images:${HOST_DISTRO}/${HOST_CODENAME} "$c"; then
    echo "  Fallback: using $FALLBACK"
    incus launch images:${FALLBACK} "$c"
  fi
  incus exec ${c} -- apt update
  incus exec ${c} -- apt install -y python3 python3-apt sudo
  incus config set ${c} security.nesting=true
  incus file push ~/.ssh/id_rsa.pub ${c}/root/.ssh/authorized_keys
  echo "Container ${c} klaar"
done
