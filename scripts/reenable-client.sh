#!/bin/sh
# Activeer een geblokkeerde WireGuard client opnieuw
set -eu

CLIENT_NAME="${1:?Geef een client naam op}"
WG_CONF="/etc/wireguard/wg0.conf"

# Verwijder #BLOCKED# uit regels
sed -i "/# $CLIENT_NAME/,/AllowedIPs/ s/^#BLOCKED#//" "$WG_CONF"

# Herlaad configuratie
wg syncconf wg0 <(wg-quick strip wg0)

echo "✅ Client $CLIENT_NAME weer geactiveerd."
