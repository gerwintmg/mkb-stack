# mkb-stack

This project provides a set of scripts and configurations to set up a server with various services running in Incus containers. The services are managed by Ansible.

## Services

The following services are set up:

*   **Samba**: File sharing
*   **Authentik**: Identity provider
*   **Forgejo**: Git service
*   **Woodpecker**: CI/CD
*   **Traefik**: Reverse proxy

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

**Note:** The Ansible roles and playbooks are not included in this repository. You will need to provide your own.