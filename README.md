# mkb-stack

## For Who is This Project

This project is a template for small businesses to set up their internal IT infrastructure without dependence on multinational corporations. Everything is based on open source with a preference for the most permissive licenses for commercial use.

## Philosophy

The base is intended to be run on a single server with applications separated in containers so that when a security incident happens, the impact can be limited. The configuration needs to be able to work with Microsoft, Linux, and Apple-based products to facilitate easy adoption to a fully independent IT infrastructure.

This project is intended to be a "click and run" solution for the most basic setup. Example configurations are included, and the goal is to generate all required configurations automatically.

## Services

The following services are set up:

*   **Samba**: File sharing (compatible with Windows, macOS, and Linux)
*   **Authentik**: Identity provider for single sign-on (SSO)
*   **Forgejo**: Self-hosted Git service
*   **Woodpecker**: CI/CD for automating software workflows
*   **Traefik**: Reverse proxy and load balancer

## Getting Started

### Prerequisites

*   A Debian-based host
*   Ansible installed on the host

### Bootstrap

1.  Clone the repository:
    ```bash
    git clone https://github.com/example/mkb-stack.git
    cd mkb-stack
    ```
2.  Run the bootstrap script:
    ```bash
    make bootstrap
    ```
    This will:
    *   Install necessary packages on the host.
    *   Configure WireGuard, SSH, and a firewall.
    *   Create Incus containers for the services.
    *   Install Python in the containers.

### Apply Configuration

To apply the Ansible configuration, run:

```bash
make apply
```

**Note:** While the goal is to provide a complete solution, the Ansible roles and playbooks are not yet fully implemented. You may need to provide your own for a complete setup.