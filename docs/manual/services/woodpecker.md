# Woodpecker CI

This document provides an overview of the Woodpecker service included in the mkb-stack.

## What is Woodpecker?

Woodpecker is a Continuous Integration (CI) tool. In simple terms, it is an automation engine that can build, test, and deploy your software projects automatically. It is a community fork of the popular Drone CI system and is known for its simplicity and ease of use.

## Why Do We Need It?

In any software project, whether it's an internal application or a website, there are repetitive tasks that need to be performed every time a change is made. These tasks can include:

*   **Building the code:** Compiling the source code into an executable application.
*   **Running tests:** Automatically running a suite of tests to ensure that the changes haven't broken anything.
*   **Packaging the application:** Creating a distributable package, like a Docker container or a zip file.
*   **Deploying the application:** Automatically deploying the new version to a server.

Performing these tasks manually is time-consuming and prone to human error. Woodpecker automates this entire process, saving you time and ensuring that every change is tested and deployed consistently.

## How Does It Work in mkb-stack?

In the mkb-stack, Woodpecker is configured to work with [Forgejo](./forgejo.md), our self-hosted Git service.

Here’s a typical workflow:

1.  **You push a change:** A developer pushes a code change to a repository in Forgejo.
2.  **Forgejo notifies Woodpecker:** Forgejo automatically sends a notification (a webhook) to Woodpecker about the new change.
3.  **Woodpecker starts a pipeline:** Woodpecker finds a `.woodpecker.yml` file in your repository. This file defines the steps to build, test, and deploy your project.
4.  **Woodpecker runs the steps:** Woodpecker executes the steps in the pipeline in a clean, isolated environment.
5.  **You get the result:** You can see the results of the pipeline in the Woodpecker web interface. If anything fails, you are notified immediately.

By integrating Woodpecker, the mkb-stack provides a complete, self-hosted software development and deployment platform, allowing your business to automate its software workflows without relying on external cloud services.