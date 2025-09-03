#!/bin/sh
# scripts/generate-manual.sh – maakt join handleiding
set -eu
# shellcheck source=scripts/settings.env
. "$(dirname "$0")/settings.env"

cat > docs/JOIN_MANUAL.md <<'EOF'
# Join Manual

## Windows
1. Open *System Properties* → *Domain join*.
2. Vul domein in: \$SAMBA_DOMAIN
3. Log in met admin: Administrator / \$SAMBA_ADMIN_PASS

## Linux
```sh
realm join --user=Administrator \$SAMBA_REALM
```

## macOS
1. *System Preferences* → *Users & Groups* → *Login Options* → *Network Account Server*.
2. Vul in: \$SAMBA_REALM
EOF