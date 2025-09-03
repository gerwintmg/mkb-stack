# Architectuur

## Netwerktopologie
- Host (Debian + Incus + Ansible)
- Container: Samba (AD)
- Container: Authentik (SSO)
- Container: Forgejo (Git)
- Container: Woodpecker (CI/CD)
- Container: Traefik (reverse proxy)

## Flow
- Windows/Mac/Linux clients joinen bij Samba AD
- Authentik koppelt aan Samba voor SSO
- Forgejo & Woodpecker authenticeren via Authentik
- Traefik ontsluit alles met TLS
