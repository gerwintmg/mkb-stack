#!/bin/sh
# scripts/lint.sh - Run all linters locally

# Continue on error, so all available linters run
set +e

LINTER_FOUND=0
LINTER_FAILURES=0

# --- ShellCheck ---
printf "\n--- Running ShellCheck ---\n"
if command -v shellcheck >/dev/null 2>&1; then
  # Exclude the virtual environment directory
  if ! find . -name "*.sh" -not -path "./.venv-mkb-stack/*" -print0 | xargs -0 shellcheck -x ; then # Check exit code directly
    printf "ShellCheck found issues.\n"
    LINTER_FAILURES=1
  else
    printf "ShellCheck passed.\n"
  fi
  LINTER_FOUND=1
else
  printf "ShellCheck not found. Install with: sudo apt-get install shellcheck for full validation.\n"
fi

# --- Ansible Lint ---
printf "\n--- Running Ansible Lint ---\n"
# Check if the named virtual environment exists and activate it
if . ".venv-mkb-stack/bin/activate" ; then
  printf "Activated Python virtual environment (.venv-mkb-stack).\n"
fi

if command -v ansible-lint >/dev/null 2>&1; then
  if ! ansible-lint ansible/; then # Check exit code directly
    printf "Ansible Lint found issues.\n"
    LINTER_FAILURES=1
  else
    printf "Ansible Lint passed.\n"
  fi
  LINTER_FOUND=1
else
  printf "Ansible Lint not found. Install with: pip install ansible-lint (preferably in a virtual environment) for full validation.\n"
fi

# --- Markdown Lint (mdl) ---
printf "\n--- Running Markdown Lint (mdl) ---\n"
if command -v mdl >/dev/null 2>&1; then
  if ! mdl --style all --warnings --config .mdlrc -g -- ./docs/* *.md ./.github/* ; then # Check exit code directly
    printf "mdl found issues.\n"
    LINTER_FAILURES=1
  else
    printf "mdl passed.\n"
  fi
  LINTER_FOUND=1
else
  printf "mdl not found. Install with: sudo apt-get install ruby && sudo gem install mdl for full validation.\n"
fi

# --- Final Summary ---
printf "\n--- Linting Summary ---\n"
if [ "$LINTER_FOUND" -eq 0 ]; then
  printf "No linters were found or run. Please install linters for validation.\n"
elif [ "$LINTER_FAILURES" -eq 0 ]; then
  printf "All enabled linters passed successfully!\n"
else
  printf "Some linters found issues. Review the output above.\n"
fi