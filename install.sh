#!/usr/bin/env bash`
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

echo "==> Checking for GNU Stow..."
if ! command -v stow &> /dev/null; then
  echo "    Not found. Installing via apt (requires sudo)..."
  sudo apt update
  sudo apt install -y stow
else
  echo "    Already installed: $(stow --version | head -n1)"
fi

echo "==> Setting up packages..."
for dir in */; do
  package="${dir%/}"

  # Skip hidden/non-package directories (e.g. .git)
  if [[ "$package" == .* ]]; then
    continue
  fi

  echo ""
  echo "--- $package ---"

  # Run the package's own install script, if it has one
  if [[ -f "$package/install.sh" ]]; then
    chmod +x "$package/install.sh"
    (cd "$package" && ./install.sh)
  fi

  echo "    Linking $package..."
  stow --no-folding "$package"
done

echo ""
echo "==> Done. All packages installed and linked into \$HOME."
