# Contributing to mkb-stack on Windows

This guide provides specific instructions for setting up your development environment on a Windows machine to contribute to the `mkb-stack` project. We highly recommend using **Windows Subsystem for Linux (WSL)** for the best experience, as the project's scripts and tools are primarily designed for a Linux/POSIX environment.

## Option 1: Recommended - Using WSL2

WSL2 allows you to run a full Linux environment directly within Windows, providing excellent compatibility with the project's tools and scripts.

1.  **Install WSL2:** Follow the official Microsoft guide to install WSL2 and your preferred Linux distribution (e.g., Ubuntu):
    [Install WSL | Microsoft Learn](https://learn.microsoft.com/en-us/windows/wsl/install)

2.  **Launch your WSL Distribution:** Open your installed Linux distribution from the Start Menu.

3.  **Follow the Main `CONTRIBUTING.md` Guide:** Once inside your WSL environment, you can follow the standard development setup instructions provided in the main [`CONTRIBUTING.md`](./CONTRIBUTING.md) file, as you are now effectively working in a Linux environment.
## Option 2: Using Git Bash (Advanced/Limited Support)

While possible, using Git Bash directly for development is generally not recommended due to potential compatibility issues with some Linux-specific tools and pathing. If you choose this option, you will need to manually install the linters and ensure they are accessible in your Git Bash PATH.

*   **Install Git Bash:** [Git for Windows](https://gitforwindows.org/)

*   **Install Linters (Manual):**
    *   **ShellCheck:** Download the Windows binary or use a package manager like Chocolatey (`choco install shellcheck`). Ensure it's in your PATH.
    *   **Ansible Lint:** Install Python for Windows and then create and activate a virtual environment before running `pip install ansible-lint` in your Git Bash terminal.
    *   **Markdown Lint (mdl):** Install Ruby for Windows and then `gem install mdl` in your Git Bash terminal.

*   **Run Local Linters:**
    ```bash
    sh scripts/lint.sh
    ```

**Note:** You may encounter issues with file paths or specific commands not behaving as expected compared to a native Linux environment. WSL2 is the preferred method for Windows users.