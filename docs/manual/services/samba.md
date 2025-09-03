# Samba

This document provides an overview of the Samba service included in the mkb-stack.

## What is Samba?

Samba is a powerful open-source implementation of the SMB/CIFS protocol, which is the standard for file and printer sharing used by Windows. In the context of the mkb-stack, Samba is configured to act as an **Active Directory (AD) Domain Controller**.

## Why Do We Need It?

A Domain Controller is the centerpiece of a traditional office network. It provides two critical functions:

1.  **Centralized User Management:** Instead of creating separate user accounts on every single computer and service, you have one central database of users and groups. This means a user has a single username and password to access their computer, file shares, and other services.

2.  **Centralized Authentication:** It acts as the gatekeeper for your network. When a user logs into their computer, the computer contacts the Domain Controller to verify their password. This ensures that only authorized users can access your company's resources.

By including Samba as a Domain Controller, the mkb-stack provides a robust foundation for a professional, secure, and easy-to-manage IT infrastructure, similar to what you would find in a large enterprise, but without the licensing costs of Windows Server.

## How Does It Work in mkb-stack?

In the mkb-stack, the Samba container provides the following:

*   **Domain Logins:** Allows Windows, macOS, and Linux computers to join a central domain (e.g., `EXAMPLE.LAN`). This enables users to log in to any domain-joined computer with their single set of credentials.
*   **File Sharing:** Provides central file storage (network drives). You can create shared folders for departments or projects and control access using domain users and groups.
*   **Group Policies (for Windows):** Allows you to define and enforce security policies and settings on all domain-joined Windows computers (e.g., password complexity requirements, desktop settings).
*   **Backend for Other Services:** The user database in Samba is used by other services in the stack, like [Authentik](./authentik.md), to provide single sign-on (SSO).

By using Samba, you can manage your users, computers, and files from a central location, which is a cornerstone of a secure and scalable IT environment.