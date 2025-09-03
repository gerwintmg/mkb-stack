# WireGuard VPN

This document provides an overview of the WireGuard VPN service included in the mkb-stack.

## What is WireGuard?

WireGuard is a modern, high-performance, and extremely simple Virtual Private Network (VPN). A VPN creates a secure, encrypted "tunnel" over the public internet between a user's device (like a laptop or phone) and a private network (like your office network).

## Why Do We Need It?

In a modern business, employees need to access company resources from outside the office. A VPN is essential for this, providing two key benefits:

1.  **Security:** It encrypts all the traffic between the user's device and the office network. This prevents eavesdroppers on public Wi-Fi (e.g., at a coffee shop or airport) from intercepting sensitive company data.

2.  **Access:** It makes the user's device behave as if it is physically connected to the office network. This allows them to access internal resources like file shares and internal websites that are not exposed to the public internet.

WireGuard is included in the mkb-stack because it is widely regarded as one of the most secure, fastest, and easiest-to-use VPN solutions available.

## How Does It Work in mkb-stack?

In the mkb-stack, the WireGuard service runs directly on the host machine.

*   **Server:** The host machine acts as the WireGuard VPN server. It listens for incoming connections from authorized clients.
*   **Clients:** To connect to the VPN, each user needs a WireGuard client application on their device and a unique configuration file.
*   **Scripts for Management:** The `scripts` directory contains several scripts to help you manage WireGuard clients:
    *   `add-wireguard-client.sh`: Generates a new configuration file and QR code for a new user.
    *   `remove-client.sh`: Revokes access for a user.
    *   `block-client.sh` / `reenable-client.sh`: Temporarily disables or re-enables a user's access.

When a user connects to the WireGuard VPN, their device is assigned an IP address on the private network, and they can securely access all the services running in the Incus containers, just as if they were in the office.