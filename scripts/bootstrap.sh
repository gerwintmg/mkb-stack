#!/bin/sh
# scripts/bootstrap.sh – maakt Incus containers klaar
set -eu
# shellcheck source=scripts/settings.env
. "$(dirname "$0")/settings.env"

FALLBACK="debian/trixie"

# Containers
for c in samba authentik forgejo woodpecker traefik; do
  printf "Launching container %s...\n" "$c"
  if ! incus launch images:"${HOST_DISTRO}""${HOST_CODENAME}" "$c"; then
    printf "  Fallback: using %s\n" "$FALLBACK"
    incus launch images:"${FALLBACK}" "$c"
  fi
  incus exec "$c" -- apt update
  incus exec "$c" -- apt install -y python3 python3-apt sudo
  incus config set "$c" security.nesting=true
  incus file push ~/.ssh/id_rsa.pub "$c"/root/.ssh/authorized_keys
  printf "Container %s klaar\n" "$c"
done