#!/bin/sh
# scripts/bootstrap-authentik-outpost.sh – Authentik Outpost + Traefik integratie
set -eu

. "$(dirname "$0")/settings.env"

OUTPOST_NAME="authentik-outpost"
OUTPOST_IMAGE="ghcr.io/goauthentik/proxy"
OUTPOST_PORT="${AUTHENTIK_OUTPOST_PORT:-9000}"

AUTHENTIK_TOKEN="${AUTHENTIK_API_TOKEN:?AUTHENTIK_API_TOKEN ontbreekt in settings.env}"
AUTHENTIK_HOST="https://${AUTHENTIK_DOMAIN}"

# -----------------------------------------------------------------------------
# 1. Container aanmaken
# -----------------------------------------------------------------------------
if ! incus info "$OUTPOST_NAME" >/dev/null 2>&1; then
  echo "➡️  Launching $OUTPOST_NAME..."
  incus launch images:debian/13 "$OUTPOST_NAME"
fi

# -----------------------------------------------------------------------------
# 2. Basis packages installeren
# -----------------------------------------------------------------------------
incus exec "$OUTPOST_NAME" -- sh -c "
  apt update &&
  apt install -y curl ca-certificates podman jq
"

# -----------------------------------------------------------------------------
# 3. Authentik Outpost automatisch aanmaken via API
# -----------------------------------------------------------------------------
echo "➡️  Controleren of outpost al bestaat..."
OUTPOST_ID=$(curl -s -H "Authorization: Bearer $AUTHENTIK_TOKEN" \
  "$AUTHENTIK_HOST/api/v3/outposts/" | jq -r \
  ".results[] | select(.name==\"$OUTPOST_NAME\") | .pk")

if [ -z "$OUTPOST_ID" ] || [ "$OUTPOST_ID" = "null" ]; then
  echo "➡️  Outpost bestaat nog niet, aanmaken..."
  OUTPOST_ID=$(curl -s -X POST "$AUTHENTIK_HOST/api/v3/outposts/" \
    -H "Authorization: Bearer $AUTHENTIK_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"$OUTPOST_NAME\", \"type\": \"proxy\"}" \
    | jq -r ".pk")
else
  echo "✅ Outpost $OUTPOST_NAME bestaat al (id=$OUTPOST_ID)"
fi

# -----------------------------------------------------------------------------
# 4. Outpost container starten
# -----------------------------------------------------------------------------
echo "➡️  Starten van de outpost container..."
incus exec "$OUTPOST_NAME" -- sh -c "
  podman rm -f authentik-outpost >/dev/null 2>&1 || true
  podman run -d --name authentik-outpost \
    --restart=always \
    -e AUTHENTIK_HOST=$AUTHENTIK_HOST \
    -e AUTHENTIK_TOKEN=$AUTHENTIK_TOKEN \
    -e AUTHENTIK_OUTPOST=$OUTPOST_ID \
    -p $OUTPOST_PORT:9000 \
    $OUTPOST_IMAGE
"

# -----------------------------------------------------------------------------
# 5. Traefik integratie (dynamic config)
# -----------------------------------------------------------------------------
TRAEFIK_HOST="traefik"
TRAEFIK_CONFIG_PATH="/etc/traefik/dynamic/authentik-outpost.yml"
OUTPOST_FQDN="outpost.${AUTHENTIK_DOMAIN}"

echo "➡️  Genereren van Traefik config voor $OUTPOST_FQDN"

cat <<EOF > /tmp/authentik-outpost.yml
http:
  routers:
    authentik-outpost:
      rule: "Host(\`$OUTPOST_FQDN\`)"
      entryPoints:
        - websecure
      service: authentik-outpost
      tls:
        certResolver: letsencrypt

  services:
    authentik-outpost:
      loadBalancer:
        servers:
          - url: "http://$OUTPOST_NAME.lxd:$OUTPOST_PORT"
EOF

incus file push /tmp/authentik-outpost.yml "$TRAEFIK_HOST$TRAEFIK_CONFIG_PATH"

# Reload Traefik
incus exec "$TRAEFIK_HOST" -- sh -c "pkill -HUP traefik || true"

echo "✅ Outpost extern bereikbaar via: https://$OUTPOST_FQDN"
