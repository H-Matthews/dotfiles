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

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------

require_stow() {
  if ! command -v stow &>/dev/null; then
    echo "Stow isn't installed — nothing to unlink (no symlinks could exist without it)."
    exit 0
  fi
}

unstow_package() {
  local package="$1"
  echo "    -> $package"
  stow -D --no-folding --ignore='^install\.sh$' "$package"
}

cleanup_empty_dirs() {
  echo "==> Cleaning up empty leftover directories..."
  for dir in */; do
    local package="${dir%/}"
    [[ "$package" == .* ]] && continue
    # Derive which dirs stow created in $HOME from the package structure,
    # then rmdir deepest-first. rmdir is a no-op on non-empty dirs.
    while IFS= read -r -d '' subdir; do
      local rel="${subdir#"$package"/}"
      rmdir "$HOME/$rel" 2>/dev/null || true
    done < <(find "$package" -mindepth 1 -type d -print0 2>/dev/null | sort -rz)
  done
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
  require_stow

  echo "==> Unlinking packages..."
  for dir in */; do
    local package="${dir%/}"

    # Skip hidden/non-package directories (e.g. .git)
    [[ "$package" == .* ]] && continue

    unstow_package "$package"
  done

  cleanup_empty_dirs

  echo ""
  echo "==> Done. All symlinks removed from \$HOME."
  echo "    Note: this does not uninstall the tools themselves (Neovim, zsh, etc.),"
  echo "    only the dotfile symlinks. It's now safe to delete this repo."
}

main
