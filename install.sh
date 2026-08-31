#!/usr/bin/env bash
#
# Bootstraps this dotfiles repo on a new machine:
#   1. Installs GNU Stow if it isn't already present
#   2. For each package folder, runs its own install.sh (if present) to
#      install that tool and its dependencies
#   3. Stows the package into $HOME
#
# Run from anywhere; the script locates its own directory.
# Usage: ./install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------

ensure_stow() {
  echo "==> Checking for GNU Stow..."
  if ! command -v stow &>/dev/null; then
    echo "    Not found. Installing via apt (requires sudo)..."
    sudo apt update
    sudo apt install -y stow
  else
    echo "    Already installed: $(stow --version | head -n1)"
  fi
}

setup_package() {
  local package="$1"

  # Link dotfiles first. --ignore keeps this script's own install.sh out of
  # the symlink (it's a bootstrap helper, not a dotfile to place in $HOME).
  # Linking before running install.sh matters for tools like Oh My Zsh,
  # which behave differently if the target config file already exists.
  echo "    Linking $package..."
  stow --no-folding --ignore='^install\.sh$' "$package"

  # Then run the package's own install script, if it has one
  if [[ -f "$package/install.sh" ]]; then
    chmod +755 "$package/install.sh"
    (cd "$package" && ./install.sh)
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
  # Validate any explicitly requested packages before doing any work
  for pkg in "$@"; do
    if [[ ! -d "$pkg" ]]; then
      echo "Error: unknown package '$pkg'" >&2
      exit 1
    fi
  done

  ensure_stow

  echo "==> Setting up packages..."
  for dir in */; do
    local package="${dir%/}"

    # Skip hidden/non-package directories (e.g. .git)
    [[ "$package" == .* ]] && continue

    # If specific packages were requested, skip all others
    if [[ $# -gt 0 ]] && [[ ! " $* " == *" $package "* ]]; then
      continue
    fi

    echo ""
    echo "--- $package ---"
    setup_package "$package"
  done

  echo ""
  if [[ $# -gt 0 ]]; then
    echo "==> Done. Package(s) installed and linked: $*"
  else
    echo "==> Done. All packages installed and linked into \$HOME."
  fi
}

main "$@"
