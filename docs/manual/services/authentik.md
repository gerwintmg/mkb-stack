# Authentik

This document provides an overview of the Authentik service included in the mkb-stack.

## What is Authentik?

Authentik is an open-source Identity Provider (IdP). Its primary job is to manage user identities and provide a secure, centralized way for your users to log in to various applications. It is the key to enabling **Single Sign-On (SSO)** across your services.

## Why Do We Need It?

In a modern IT environment, you have many different applications (e.g., Git, CI/CD, internal websites). Without a central identity provider, you would need to manage user accounts and passwords in each of these applications separately. This leads to several problems:

*   **Password Fatigue:** Users have to remember many different passwords.
*   **Security Risks:** Users tend to reuse passwords, so a breach in one application can compromise others.
*   **Management Overhead:** When an employee joins or leaves the company, you have to create or delete their account in every single application.

Authentik solves these problems by providing a single, secure place to manage all user identities and a single login portal for all your applications.

## How Does It Work in mkb-stack?

In the mkb-stack, Authentik is the central hub for user authentication.

Here's the workflow:

1.  **User Database:** Authentik is configured to use our [Samba](./samba.md) Active Directory as its primary user database. This means you don't have to manage users in two places; Authentik uses the same user accounts you created in Samba.

2.  **Login Portal:** When you try to access a service like [Forgejo](./forgejo.md), you are redirected to the Authentik login page.

3.  **Authentication:** You log in to Authentik using your domain credentials. Authentik verifies these credentials against the Samba user database.

4.  **Redirection:** After a successful login, Authentik redirects you back to the application (e.g., Forgejo), and you are automatically logged in.

5.  **Single Sign-On:** If you then try to access another service, like [Woodpecker](./woodpecker.md), Authentik will remember that you are already logged in and will automatically log you into that service without asking for your password again.

By using Authentik, the mkb-stack provides a seamless and secure login experience for your users, while simplifying user management for your administrators.