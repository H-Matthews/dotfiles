#!/usr/bin/env bash
#
# Cleanly removes every symlink this repo's install.sh created, by
# running `stow -D` (delete) for each package folder.
#
# Run this BEFORE deleting the repo — once the repo is gone, Stow has
# nothing to compare against and can't clean up the dangling symlinks
# it left behind.
#
# Run from anywhere; the script locates its own directory.
# Usage: ./clean.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v stow &> /dev/null; then
  echo "Stow isn't installed — nothing to unlink (no symlinks could exist without it)."
  exit 0
fi

echo "==> Unlinking packages..."
for dir in */; do
  package="${dir%/}"

  # Skip hidden/non-package directories (e.g. .git)
  if [[ "$package" == .* ]]; then
    continue
  fi

  echo "    -> $package"
  stow -D --no-folding --ignore='^install\.sh$' "$package"
done

echo "==> Cleaning up empty leftover directories..."
find "$HOME/.config" -type d -empty -delete 2>/dev/null || true

echo ""
echo "==> Done. All symlinks removed from \$HOME."
echo "    Note: this does not uninstall the tools themselves (Neovim, zsh, etc.),"
echo "    only the dotfile symlinks. It's now safe to delete this repo."
