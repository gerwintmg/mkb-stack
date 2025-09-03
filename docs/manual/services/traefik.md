# Traefik Proxy

This document provides an overview of the Traefik Proxy service included in the mkb-stack.

## What is Traefik?

Traefik is a modern, open-source **reverse proxy** and **load balancer**. Its primary job is to be the main entry point for all incoming network traffic to your server and to route that traffic to the correct backend service (i.e., the correct container).

## Why Do We Need It?

In our container-based setup, we have several different services (Authentik, Forgejo, etc.) running in their own isolated containers. A reverse proxy like Traefik is essential for several reasons:

*   **Simplifies Access:** Instead of having to remember the IP address and port for every single service, you can access everything through a simple, memorable domain name (e.g., `git.example.com`, `login.example.com`).
*   **Automated SSL/TLS:** Traefik automatically integrates with [Let's Encrypt](https://letsencrypt.org/) to obtain and renew free SSL/TLS certificates for all your services. This ensures that all communication between your users and your services is encrypted and secure (HTTPS).
*   **Centralized Management:** It provides a single place to manage how your services are exposed to the internet. You can easily add, remove, or change services without having to reconfigure your firewall or DNS.
*   **Load Balancing:** While we are running on a single server, Traefik is also a powerful load balancer. This means that if you were to scale up and run multiple instances of a service, Traefik could distribute the traffic between them.

## How Does It Work in mkb-stack?

In the mkb-stack, Traefik is the gatekeeper for all your services.

1.  **Entry Point:** All incoming web traffic (ports 80 and 443) is directed to the Traefik container.
2.  **Automatic Discovery:** Traefik is configured to automatically discover the other services running in the Incus containers. It does this by inspecting the container labels.
3.  **Routing:** When a request comes in for `git.example.com`, Traefik knows that it should route this request to the Forgejo container. When a request comes in for `login.example.com`, it routes it to the Authentik container.
4.  **SSL Termination:** Traefik handles the SSL/TLS encryption. It terminates the encrypted connection from the user and then forwards the unencrypted traffic to the backend service over the private network. This simplifies the configuration of the backend services, as they don't need to worry about SSL.

By using Traefik, the mkb-stack provides a secure, professional, and easy-to-manage way to access all of your self-hosted services.