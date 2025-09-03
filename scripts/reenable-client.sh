#!/bin/sh
# Activeer een geblokkeerde WireGuard client opnieuw
set -eu

CLIENT_NAME="${1:?Geef een client naam op}"
WG_CONF="/etc/wireguard/wg0.conf"

# Verwijder #BLOCKED# uit regels
sed -i "/# $CLIENT_NAME/,/AllowedIPs/ s/^#BLOCKED#//" "$WG_CONF"

# Herlaad configuratie
WG_STRIP_CONF=$(mktemp)
wg-quick strip wg0 > "$WG_STRIP_CONF"
wg syncconf wg0 "$WG_STRIP_CONF"
rm "$WG_STRIP_CONF"

printf "✅ Client %s weer geactiveerd.\n" "$CLIENT_NAME"