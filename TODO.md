# TODO

This file outlines the major tasks required to complete the mkb-stack project.

## Phase 1: Core Infrastructure

- [ ] **Host Setup (`scripts/host-setup.sh`)**
    - [ ] Review and refine the package installation list.
    - [ ] Make the firewall configuration more robust (e.g., add more rules, logging).
    - [ ] Test the script on a clean Debian installation.

- [ ] **Container Bootstrap (`scripts/bootstrap.sh`)**
    - [ ] Parameterize the container images and versions.
    - [ ] Add error handling and retries for container creation.

- [ ] **WireGuard Management Scripts**
    - [ ] `add-wireguard-client.sh`: Improve IP address allocation.
    - [ ] `remove-client.sh`: Add an option to revoke certificates.
    - [ ] `block-client.sh` and `reenable-client.sh`: Ensure they are idempotent.

## Phase 2: Ansible Automation

- [ ] **Ansible Roles**
    - [ ] **Samba**
        - [ ] Implement the Samba role to configure it as an Active Directory domain controller.
        - [ ] Add tasks for creating shares and managing users.
        - [ ] Test joining Windows, macOS, and Linux clients to the domain.
    - [ ] **Authentik**
        - [ ] Implement the Authentik role to configure it for SSO.
        - [ ] Add tasks for integrating with Samba as a user backend.
        - [ ] Configure Authentik to manage other services (Forgejo, Woodpecker).
    - [ ] **Forgejo**
        - [ ] Implement the Forgejo role to install and configure it.
        - [ ] Configure Forgejo to use Authentik for authentication.
    - [ ] **Woodpecker**
        - [ ] Implement the Woodpecker role to install and configure it.
        - [ ] Configure Woodpecker to use Forgejo as a backend.
        - [ ] Configure Woodpecker to use Authentik for authentication.
    - [ ] **Traefik**
        - [ ] Implement the Traefik role to configure it as a reverse proxy.
        - [ ] Add tasks for creating routes to the other services.
        - [ ] Configure Traefik to use Let's Encrypt for SSL certificates.
    - [ ] **Mail Server**
        - [ ] **Default Relay Server:** Implement a simple mail relay container (e.g., using Postfix) that sends all mail through an external provider. This should be the default, easy-to-configure option.
        - [ ] **Optional Full Mail Server:**
            - [ ] Research and select a full-featured mail server stack (e.g., Postfix, Dovecot, Rspamd).
            - [ ] Implement the mail server as an optional, separate set of containers.
            - [ ] Add the necessary firewall rules and Fail2ban configurations, which should only be applied if the user enables the full mail server.
            - [ ] Document the complex DNS configuration (MX, SPF, DKIM, DMARC) required for a self-hosted mail server.

- [ ] **Configuration Generation**
    - [ ] Create a script to generate the `ansible/inventories/hosts.yml` and `ansible/inventories/group_vars/all.yml` files from a simpler configuration file.
    - [ ] The script should prompt the user for required information (e.g., domain names, passwords).

## Phase 3: Documentation and Usability

- [ ] **Documentation**
    - [ ] Update the `README.md` with more detailed instructions and a better project description.
    - [ ] Create a `docs/USER_GUIDE.md` that explains how to use the services.
    - [ ] Review and update all existing documentation.

- [ ] **Testing**
    - [ ] Create a test plan to verify the functionality of the entire stack.
    - [ ] Automate the testing process as much as possible.

- [ ] **Security**
    - [ ] Perform a security audit of the entire stack.
    - [ ] Implement security hardening measures where necessary.

## Phase 4: Advanced Scenarios

- [ ] **Onboarding Remote Employees (Pre-Logon VPN)**
    - [ ] **Design:**
        - [ ] Finalize the choice of pre-logon VPN solution (likely OpenVPN).
        - [ ] Design the service to be **optional and disabled by default**. This will likely involve a variable in the main configuration file.
    - [ ] **Implementation:**
        - [ ] Add a new container for the OpenVPN server to the stack, which is only created if the service is enabled.
        - [ ] Create a new Ansible role to automate the installation and configuration of the OpenVPN server.
    - [ ] **Documentation:**
        - [ ] Create a new documentation page explaining how to enable and use the pre-logon VPN for onboarding remote employees.
        - [ ] Document the process for generating and distributing client configuration files.