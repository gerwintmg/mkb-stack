#!/bin/sh
# scripts/host-setup.sh – draait op de Debian host
set -eu

. $(dirname "$0")/settings.env

# Basis tools
apt update && apt install -y ufw fail2ban incus ansible git make

# Firewall
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw enable

# Incus init (non-interactive)
incus admin init --minimal

# SSH key voor Ansible distributie
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi
