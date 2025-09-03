#!/bin/sh
# scripts/lint.sh - Run all linters locally

# Continue on error, so all available linters run
set +e

LINTER_FOUND=0

# --- ShellCheck ---
echo "\n--- Running ShellCheck ---"
if command -v shellcheck >/dev/null 2>&1; then
  # Exclude the virtual environment directory
  find . -name "*.sh" -not -path "./.venv-mkb-stack/*" -print0 | xargs -0 shellcheck
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
# Check if the named virtual environment exists and activate it
if [ -f ".venv-mkb-stack/bin/activate" ]; then
  . .venv-mkb-stack/bin/activate
  echo "Activated Python virtual environment (.venv-mkb-stack)."
fi

if command -v ansible-lint >/dev/null 2>&1; then
  ansible-lint ansible/
  if [ $? -ne 0 ]; then
    echo "Ansible Lint found issues."
  else
    echo "Ansible Lint passed."
  fi
  LINTER_FOUND=1
else
  echo "Ansible Lint not found. Install with: pip install ansible-lint (preferably in a virtual environment) for full validation."
fi

# --- Markdown Lint (mdl) ---
echo "\n--- Running Markdown Lint (mdl) ---"
if command -v mdl >/dev/null 2>&1; then
  mdl --style all --warnings --config .mdlrc "**/*.md"
  if [ $? -ne 0 ]; then
    echo "mdl found issues."
  else
    echo "mdl passed."
  fi
  LINTER_FOUND=1
else
  echo "mdl not found. Install with: sudo apt-get install ruby && sudo gem install mdl for full validation."
fi

# --- Final Summary ---
echo "\n--- Linting Summary ---"
if [ "$LINTER_FOUND" -eq 0 ]; then
  echo "No linters were found or run. Please install linters for validation."
else
  echo "Linting complete. Review the output above for any issues."
fi