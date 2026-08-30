#!/usr/bin/env bash
#
# Installs Neovim and everything its config depends on:
#   - Neovim itself (via the official .deb, since apt's version usually lags)
#   - A C compiler (needed to build treesitter parsers)
#   - tree-sitter-cli 0.26.1+ (needed by nvim-treesitter's main branch)
#   - ripgrep (used by Telescope's live grep)

set -euo pipefail

MIN_TS_VERSION="0.26.1"

version_ge() {
  # Returns 0 (true) if $1 >= $2
  [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

echo "==> Neovim"
if command -v nvim &> /dev/null; then
  echo "    Already installed: $(nvim --version | head -n1)"
else
  echo "    Not found. Downloading latest release..."
  TMP_DEB="$(mktemp --suffix=.deb)"
  curl -Lo "$TMP_DEB" \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.deb"
  sudo apt install -y "$TMP_DEB"
  rm -f "$TMP_DEB"
fi

echo "==> C compiler"
if command -v cc &> /dev/null || command -v gcc &> /dev/null; then
  echo "    Already installed."
else
  echo "    Not found. Installing build-essential..."
  sudo apt update
  sudo apt install -y build-essential
fi

echo "==> tree-sitter-cli"
CURRENT_TS_VERSION="$(tree-sitter --version 2>/dev/null | awk '{print $2}' || echo "0.0.0")"
if command -v tree-sitter &> /dev/null && version_ge "$CURRENT_TS_VERSION" "$MIN_TS_VERSION"; then
  echo "    Already installed: $CURRENT_TS_VERSION"
else
  echo "    Missing or outdated (found: $CURRENT_TS_VERSION, need: $MIN_TS_VERSION+). Installing prebuilt binary..."
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64)  TS_ASSET="tree-sitter-linux-x64.gz" ;;
    aarch64) TS_ASSET="tree-sitter-linux-arm64.gz" ;;
    *) echo "    Unrecognized architecture ($ARCH) — install tree-sitter-cli manually." && exit 1 ;;
  esac
  TMP_GZ="$(mktemp --suffix=.gz)"
  curl -Lo "$TMP_GZ" "https://github.com/tree-sitter/tree-sitter/releases/latest/download/${TS_ASSET}"
  gunzip -c "$TMP_GZ" | sudo tee /usr/local/bin/tree-sitter > /dev/null
  sudo chmod +x /usr/local/bin/tree-sitter
  rm -f "$TMP_GZ"
  echo "    Installed: $(tree-sitter --version)"
fi

echo "==> ripgrep"
if command -v rg &> /dev/null; then
  echo "    Already installed."
else
  echo "    Not found. Installing..."
  sudo apt update
  sudo apt install -y ripgrep
fi

echo "==> nvim package dependencies satisfied."
