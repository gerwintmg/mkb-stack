# Firewall and Fail2ban

This document provides an overview of the firewall and Fail2ban configuration included in the mkb-stack.

## The Firewall (iptables)

### What is a Firewall?

A firewall is a network security system that monitors and controls incoming and outgoing network traffic based on predetermined security rules. It acts as a barrier between a trusted internal network and untrusted external networks, such as the internet.

### How is it Used in mkb-stack?

The mkb-stack uses `iptables`, the standard firewall utility in Linux, to secure the host machine. The firewall is configured with a "default deny" policy, which means that all incoming traffic is blocked unless it is explicitly allowed by a rule.

By default, we only allow incoming traffic for a few essential services:

*   **WireGuard VPN:** To allow remote users to connect to the VPN.

All other ports, including SSH, are **not** exposed to the public internet. This dramatically reduces the attack surface of the server.

### SSH Access

To manage the server via SSH, you **must first connect to the WireGuard VPN**. The firewall is configured to only accept SSH connections from within the secure VPN tunnel. This is a critical security feature that prevents attackers on the internet from directly targeting the SSH port.

### Optional: Self-Hosted Mail Server

The mkb-stack is designed to use an external email provider by default (e.g., Office 365, Google Workspace). This is the recommended and most reliable configuration.

However, the stack will include an **optional** feature to run a full, self-hosted mail server. If you choose to enable this feature, the firewall will be automatically updated to allow incoming traffic for the necessary email protocols:

*   **SMTP (port 25):** To receive incoming email from other mail servers on the internet.
*   **IMAP (port 993) and POP3 (port 995):** To allow email clients (like Outlook or Thunderbird) to connect and retrieve email.

For more details on this feature, please see the (yet to be created) mail server documentation.

## Fail2ban

### What is Fail2ban?

Fail2ban is an intrusion prevention software framework that protects computer servers from brute-force attacks. It works by monitoring log files for suspicious activity, such as repeated failed login attempts, and then temporarily or permanently banning the offending IP addresses.

### How is it Used in mkb-stack?

Fail2ban provides an important layer of **defense-in-depth**.

In the mkb-stack, Fail2ban is configured to monitor:

*   **SSH Logs:** Even though the SSH port is not public, Fail2ban still monitors it. If an attacker were to somehow gain access to the VPN, Fail2ban would detect and block any attempts to brute-force the SSH password from within the VPN.
*   **WireGuard:** Fail2ban also monitors the WireGuard service for suspicious activity and can block IP addresses that are sending malformed or unauthorized packets.

If the optional self-hosted mail server is enabled, Fail2ban will also be configured to monitor the mail server logs for failed login attempts and other suspicious activity, providing an essential layer of security for your email system.