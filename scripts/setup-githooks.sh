#!/bin/sh
# scripts/setup-githooks.sh - Configure Git to use .githooks directory

set -eu

REPO_ROOT="$(git rev-parse --show-toplevel)"

echo "Configuring Git hooks path..."
git config core.hooksPath "$REPO_ROOT/.githooks"

echo "Git hooks configured successfully!"
echo "The pre-commit hook will now run linters before each commit."
