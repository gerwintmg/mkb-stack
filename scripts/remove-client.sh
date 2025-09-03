#!/bin/sh
# Verwijder een WireGuard client volledig
set -eu

CLIENT_NAME="${1:?Geef een client naam op}"
WG_CONF="/etc/wireguard/wg0.conf"

# Verwijder peer uit de configuratie
awk -v name="$CLIENT_NAME" '
  BEGIN {skip=0}
  /^\[Peer\]/ {skip=0}
  $0 ~ "# "name {skip=1; next}
  skip==1 && NF==0 {skip=0; next}
  skip==1 {next}
  {print}
' "$WG_CONF" > "$WG_CONF.tmp"

mv "$WG_CONF.tmp" "$WG_CONF"

# Herlaad configuratie
wg syncconf wg0 <(wg-quick strip wg0)

echo "✅ Client $CLIENT_NAME verwijderd."
