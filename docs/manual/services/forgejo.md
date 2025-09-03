# Forgejo

This document provides an overview of the Forgejo service included in the mkb-stack.

## What is Forgejo?

Forgejo is a self-hosted, open-source Git service. It is a community-managed fork of Gitea and provides a lightweight and easy-to-use platform for hosting your software projects. Think of it as your own private GitHub or GitLab, running on your own server.

## Why Do We Need It?

If your business develops any kind of software, scripts, or even complex configuration files, you need a way to manage the source code. A Git service like Forgejo provides several key benefits:

*   **Version Control:** It allows you to keep a complete history of all changes made to your code. You can see who changed what, when, and why. If a change causes a problem, you can easily revert to a previous version.
*   **Collaboration:** It provides a central place for your team to collaborate on code. Developers can work on different features in parallel and then merge their changes together.
*   **Code Management:** It provides a web interface for managing your repositories, including features like pull requests, issue tracking, and wikis.
*   **Data Sovereignty:** By hosting your own Git service, you retain full control over your source code. You are not dependent on a third-party cloud provider, and your code is not subject to their terms of service.

## How Does It Work in mkb-stack?

In the mkb-stack, Forgejo is the central hub for all your source code.

*   **Authentication:** Forgejo is configured to use [Authentik](./authentik.md) for single sign-on (SSO). This means your users can log in to Forgejo with their standard domain credentials.
*   **Integration with CI/CD:** Forgejo is tightly integrated with [Woodpecker](./woodpecker.md), our CI/CD service. When you push changes to a repository in Forgejo, it can automatically trigger a build and test pipeline in Woodpecker.
*   **Private and Secure:** Because Forgejo is running on your own server within your private network, your source code is kept secure and confidential.

By including Forgejo, the mkb-stack provides a complete, self-hosted platform for managing and collaborating on your software projects.