#!/bin/sh
# scripts/add-wireguard-client.sh – Voeg een WireGuard client toe en genereer config + QR-code
set -eu

. "$(dirname "$0")/settings.env"

WG_CONF="/etc/wireguard/wg0.conf"
CLIENT_NAME="${1:-client1}"
CLIENT_DIR="$(pwd)/clients"

mkdir -p "$CLIENT_DIR"

# -----------------------------------------------------------------------------
# Genereer client keypair
# -----------------------------------------------------------------------------
umask 077
CLIENT_PRIV=$(wg genkey)
CLIENT_PUB=$(echo "$CLIENT_PRIV" | wg pubkey)

# -----------------------------------------------------------------------------
# Bepaal volgend IP
# -----------------------------------------------------------------------------
LAST_IP=$(grep AllowedIPs "$WG_CONF" | tail -n1 | awk '{print $3}' | cut -d/ -f1 || true)
if [ -z "$LAST_IP" ]; then
  CLIENT_IP="10.8.0.2"
else
  OCTET=$(echo "$LAST_IP" | awk -F. '{print $4}')
  CLIENT_IP="10.8.0.$((OCTET+1))"
fi

# -----------------------------------------------------------------------------
# Voeg peer toe aan serverconfig
# -----------------------------------------------------------------------------
cat >> "$WG_CONF" <<EOF

[Peer]
# $CLIENT_NAME
PublicKey = $CLIENT_PUB
AllowedIPs = $CLIENT_IP/32
EOF

# Herlaad WireGuard configuratie
wg syncconf wg0 <(wg-quick strip wg0)

# -----------------------------------------------------------------------------
# Maak client config
# -----------------------------------------------------------------------------
SERVER_PUBKEY=$(cat /etc/wireguard/server_public.key)
SERVER_ENDPOINT="${WG_ENDPOINT:-$(hostname -I | awk '{print $1}')}:${WG_PORT:-51820}"

CLIENT_CONF="$CLIENT_DIR/$CLIENT_NAME.conf"

cat > "$CLIENT_CONF" <<EOF
[Interface]
PrivateKey = $CLIENT_PRIV
Address = $CLIENT_IP/32
DNS = 1.1.1.1

[Peer]
PublicKey = $SERVER_PUBKEY
Endpoint = $SERVER_ENDPOINT
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF

chmod 600 "$CLIENT_CONF"

# -----------------------------------------------------------------------------
# QR-code maken (als qrencode aanwezig is)
# -----------------------------------------------------------------------------
if command -v qrencode >/dev/null 2>&1; then
  qrencode -t ansiutf8 < "$CLIENT_CONF"
  qrencode -o "$CLIENT_CONF.png" < "$CLIENT_CONF"
  echo "QR-code gegenereerd: $CLIENT_CONF.png"
else
  echo "⚠️  qrencode niet geïnstalleerd. Installeer met: apt install qrencode"
fi

echo "✅ Clientconfig gemaakt: $CLIENT_CONF"
echo "Importeer dit bestand in de WireGuard client of scan de QR-code."
