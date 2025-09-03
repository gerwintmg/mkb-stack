# Contributing to mkb-stack

Thank you for your interest in contributing to mkb-stack!

## Project Philosophy

This project is a template for small businesses to set up their internal IT infrastructure without dependence on multinational corporations. We prioritize open-source solutions with permissive licenses for commercial use.

The goal is to create a secure and stable base that can be run on a single server, with applications separated in containers to limit the impact of security incidents. The configuration should be compatible with Microsoft, Linux, and Apple-based products.

## Scripting Guidelines

All scripts should be POSIX compatible unless absolutely not possible. If a script is not POSIX compatible, it must be documented in the script's comments.

## Development Setup

1.  **Prerequisites:**
    *   A Debian-based host.
    *   Git installed.

    > [!NOTE]
    > If you are developing on Windows, we highly recommend using [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install) for the best experience. Please refer to [`CONTRIBUTING-WINDOWS.md`](./CONTRIBUTING-WINDOWS.md) for detailed setup instructions.

2.  **Clone the repository:**
    ```bash
    git clone https://github.com/example/mkb-stack.git
    cd mkb-stack
    ```

3.  **Enable Git Hooks (Recommended):**

    To ensure code quality and consistency, this project uses Git hooks to run linters automatically before each commit. To enable these hooks, run the setup script once after cloning the repository:

    ```bash
    sh scripts/setup-githooks.sh
    ```

4.  **Bootstrap the environment:**
    ```bash
    make bootstrap
    ```
    This will set up the host with the necessary software and create the Incus containers.

## Making Changes

1.  Create a new branch for your changes:
    ```bash
    git checkout -b my-feature-branch
    ```

2.  Make your changes to the scripts or configuration files.

3.  **Validate your changes locally (Recommended):**

    Before submitting a pull request, you can run the same linters that are used in the automated validation. This helps you catch errors early and ensures a smoother contribution process.

    First, you will need to install the necessary linters:
    ```bash
    # For shell scripts
    sudo apt-get install shellcheck

    # For Ansible
    pip install ansible-lint

    # For Markdown
    npm install -g markdownlint-cli
    ```

    Then, you can run the local linting script:
    ```bash
    sh scripts/lint.sh
    ```

4.  Test your changes by running the bootstrap and apply commands:
    ```bash
    make bootstrap
    make apply
    ```

5.  Commit your changes with a clear and descriptive commit message:
    ```bash
    git commit -m "feat: Add new feature"
    ```

6.  Push your changes to your fork:
    ```bash
    git push origin my-feature-branch
    ```

7.  Open a pull request against the `main` branch of the original repository.

## Ansible Roles

This repository does not contain the Ansible roles and playbooks. You will need to provide your own. The `Makefile` expects a `site.yml` file in the `ansible` directory.