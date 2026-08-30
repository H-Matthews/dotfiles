#!/usr/bin/env bash
#
# Installs zsh itself if it isn't already present.

set -euo pipefail

OMZ_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

echo "==> zsh"
if command -v zsh &> /dev/null; then
  echo "    Already installed: $(zsh --version)"
else
  echo "    Not found. Installing..."
  sudo apt update
  sudo apt install -y zsh
fi

echo "==> Oh My Zsh"
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "    Already installed."
else
  echo "    Not found. Installing..."
  # RUNZSH=no   -> don't drop into a new zsh shell when the installer finishes
  #                (would otherwise hang this script waiting on an interactive shell)
  # CHSH=no     -> don't change the login shell here; do that yourself if you want it
  # KEEP_ZSHRC=yes -> critical: your .zshrc is a symlink back into this repo, so we
  #                   must NOT let the installer overwrite/back it up with its template
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL "$OMZ_INSTALL_URL")"
fi

echo "==> zsh package dependencies satisfied."
echo "    Note: this does not change your default shell. Run 'chsh -s \$(which zsh)' if you want zsh as your login shell."
