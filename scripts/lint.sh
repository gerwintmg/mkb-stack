#!/bin/sh
# scripts/lint.sh - Run all linters locally

# Continue on error, so all available linters run
set +e

LINTER_FOUND=0

# --- ShellCheck ---
echo "\n--- Running ShellCheck ---"
if command -v shellcheck >/dev/null 2>&1; then
  find . -name "*.sh" -print0 | xargs -0 shellcheck
  if [ $? -ne 0 ]; then
    echo "ShellCheck found issues."
  else
    echo "ShellCheck passed."
  fi
  LINTER_FOUND=1
else
  echo "ShellCheck not found. Install with: sudo apt-get install shellcheck for full validation."
fi

# --- Ansible Lint ---
echo "\n--- Running Ansible Lint ---"
if command -v ansible-lint >/dev/null 2>&1; then
  ansible-lint ansible/
  if [ $? -ne 0 ]; then
    echo "Ansible Lint found issues."
  else
    echo "Ansible Lint passed."
  fi
  LINTER_FOUND=1
else
  echo "Ansible Lint not found. Install with: pip install ansible-lint for full validation."
fi

# --- MarkdownLint ---
echo "\n--- Running MarkdownLint ---"
if command -v markdownlint >/dev/null 2>&1; then
  markdownlint "**/*.md"
  if [ $? -ne 0 ]; then
    echo "MarkdownLint found issues."
  else
    echo "MarkdownLint passed."
  fi
  LINTER_FOUND=1
else
  echo "MarkdownLint not found. Install with: npm install -g markdownlint-cli for full validation."
fi

# --- Final Summary ---
echo "\n--- Linting Summary ---"
if [ "$LINTER_FOUND" -eq 0 ]; then
  echo "No linters were found or run. Please install linters for validation."
else
  echo "Linting complete. Review the output above for any issues."
fi