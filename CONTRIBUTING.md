# Contributing to mkb-stack

Thank you for your interest in contributing to mkb-stack!

## Development Setup

1.  **Prerequisites:**
    *   A Debian-based host.
    *   Git installed.

2.  **Clone the repository:**
    ```bash
    git clone https://github.com/example/mkb-stack.git
    cd mkb-stack
    ```

3.  **Bootstrap the environment:**
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

3.  Test your changes by running the bootstrap and apply commands:
    ```bash
    make bootstrap
    make apply
    ```

4.  Commit your changes with a clear and descriptive commit message:
    ```bash
    git commit -m "feat: Add new feature"
    ```

5.  Push your changes to your fork:
    ```bash
    git push origin my-feature-branch
    ```

6.  Open a pull request against the `main` branch of the original repository.

## Ansible Roles

This repository does not contain the Ansible roles and playbooks. You will need to provide your own. The `Makefile` expects a `site.yml` file in the `ansible` directory.
