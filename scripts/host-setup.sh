#!/bin/sh
# scripts/host-setup.sh – draait op de Debian host (met POSIX sh)
set -eu

. "$(dirname "$0")/settings.env"

# -----------------------------------------------------------------------------
# Basis packages
# -----------------------------------------------------------------------------
apt update
apt install -y \
  iptables iptables-persistent \
  nftables geoip-database xtables-addons-common \
  openssh-server wireguard \
  fail2ban incus ansible git make

# -----------------------------------------------------------------------------
# SSH hardening
# -----------------------------------------------------------------------------
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' /etc/ssh/sshd_config
sed -i 's/^#*UsePAM.*/UsePAM yes/' /etc/ssh/sshd_config
systemctl enable ssh
systemctl restart ssh

# -----------------------------------------------------------------------------
# WireGuard configuratie
# -----------------------------------------------------------------------------
WG_CONF="/etc/wireguard/wg0.conf"

# Maak keypair als het nog niet bestaat
if [ ! -f /etc/wireguard/server_private.key ]; then
  umask 077
  wg genkey | tee /etc/wireguard/server_private.key | wg pubkey > /etc/wireguard/server_public.key
fi

SERVER_PRIVKEY=$(cat /etc/wireguard/server_private.key)
SERVER_PUBKEY=$(cat /etc/wireguard/server_public.key)

cat > "$WG_CONF" <<EOF
[Interface]
Address = ${WG_ADDRESS:-10.8.0.1/24}
ListenPort = ${WG_PORT:-51820}
PrivateKey = $SERVER_PRIVKEY
SaveConfig = true

# Voorbeeld client kan later toegevoegd worden:
# [Peer]
# PublicKey = CLIENTPUBKEY
# AllowedIPs = 10.8.0.2/32
EOF

chmod 600 "$WG_CONF"
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0

# voor client configuratie qr-code
apt install qrencode -y

# -----------------------------------------------------------------------------
# Firewall met iptables
# -----------------------------------------------------------------------------
# Reset
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# Default policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Loopback toestaan
iptables -A INPUT -i lo -j ACCEPT

# Sta established/related toe
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# WireGuard poort toestaan (UDP)
iptables -A INPUT -p udp --dport ${WG_PORT:-51820} -j ACCEPT

# SSH alleen via WireGuard subnet toestaan
iptables -A INPUT -p tcp -s ${WG_SUBNET:-10.8.0.0/24} --dport 22 -j ACCEPT

# Optioneel: landenfilter (voorbeeld: alleen NL en BE)
# iptables -m geoip --src-cc NL,BE -j ACCEPT
# iptables -j DROP

# Sla regels op
netfilter-persistent save

# -----------------------------------------------------------------------------
# Fail2ban configuratie
# -----------------------------------------------------------------------------
cat > /etc/fail2ban/jail.local <<EOF
[sshd]
enabled = true
port    = ssh
logpath = /var/log/auth.log
backend = systemd
maxretry = 5
bantime = 1h

[wg-iptables]
enabled = true
filter  = wg-iptables
action  = iptables[name=WireGuard, port=${WG_PORT:-51820}, protocol=udp]
logpath = /var/log/syslog
maxretry = 5
EOF

systemctl enable fail2ban
systemctl restart fail2ban

# -----------------------------------------------------------------------------
# Incus init (non-interactive)
# -----------------------------------------------------------------------------
incus admin init --minimal

# -----------------------------------------------------------------------------
# SSH key voor Ansible distributie
# -----------------------------------------------------------------------------
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi

echo "Host setup voltooid. WireGuard draait op UDP poort ${WG_PORT:-51820}."
