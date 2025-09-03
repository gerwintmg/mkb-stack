#!/bin/sh
# Deactiveer een WireGuard client tijdelijk
set -eu

CLIENT_NAME="${1:?Geef een client naam op}"
WG_CONF="/etc/wireguard/wg0.conf"

# Comment peer sectie uit
sed -i "/# $CLIENT_NAME/,/AllowedIPs/ s/^/#BLOCKED#/" "$WG_CONF"

# Herlaad configuratie
wg syncconf wg0 <(wg-quick strip wg0)

echo "⛔ Client $CLIENT_NAME geblokkeerd."
