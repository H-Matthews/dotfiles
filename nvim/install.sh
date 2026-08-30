#!/usr/bin/env bash
#
# Installs Neovim and everything its config depends on:
#   - Neovim itself (via the official .tar.gz release, since apt's version
#     usually lags and there is no official .deb from neovim/neovim)
#   - A C compiler (needed to build treesitter parsers)
#   - tree-sitter-cli (needed by nvim-treesitter's main branch)
#   - ripgrep (used by Telescope's live grep)

set -euo pipefail

# ---------------------------------------------------------------------------
# Pinned versions — bump these to upgrade a tool
# ---------------------------------------------------------------------------

NVIM_VERSION="0.12.5"
TS_VERSION="0.27.0"

NVIM_RELEASE_BASE_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}"
TS_RELEASE_BASE_URL="https://github.com/tree-sitter/tree-sitter/releases/download/v${TS_VERSION}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

get_arch() {
  local arch
  arch="$(uname -m)"
  case "$arch" in
    x86_64)  echo "x86_64" ;;
    aarch64) echo "aarch64" ;;
    *) echo "    Unrecognized architecture ($arch) — install manually." >&2 && exit 1 ;;
  esac
}

ensure_apt_package() {
  sudo apt update
  sudo apt install -y "$@"
}

# install_tarball_binary <url> <opt-dir-name> <bin-rel-path> <link-name>
#   Downloads a .tar.gz, extracts it to /opt, and symlinks the binary.
install_tarball_binary() {
  local url="$1" dir_name="$2" bin_rel="$3" link_name="$4"
  local tmp
  tmp="$(mktemp --suffix=.tar.gz)"
  curl -Lo "$tmp" "$url"
  sudo rm -rf "/opt/${dir_name}"
  sudo tar -C /opt -xzf "$tmp"
  sudo ln -sf "/opt/${dir_name}/${bin_rel}" "/usr/local/bin/${link_name}"
  rm -f "$tmp"
}

# install_gz_binary <url> <dest-name>
#   Downloads a gzip-compressed binary and installs it to /usr/local/bin.
install_gz_binary() {
  local url="$1" dest_name="$2"
  local tmp
  tmp="$(mktemp --suffix=.gz)"
  curl -Lo "$tmp" "$url"
  gunzip -c "$tmp" | sudo tee "/usr/local/bin/${dest_name}" > /dev/null
  sudo chmod +x "/usr/local/bin/${dest_name}"
  rm -f "$tmp"
}

# ---------------------------------------------------------------------------
# Install functions
# ---------------------------------------------------------------------------

install_neovim() {
  echo "==> Neovim (pinned: ${NVIM_VERSION})"
  local current
  current="$(nvim --version 2>/dev/null | head -n1 | awk '{print $2}' || echo "")"
  current="${current#v}"

  if command -v nvim &>/dev/null && [ "$current" = "$NVIM_VERSION" ]; then
    echo "    Already installed: ${current}"
    return
  fi

  echo "    Installing v${NVIM_VERSION}..."
  local arch asset dir_name
  arch="$(get_arch)"
  case "$arch" in
    x86_64)  asset="nvim-linux-x86_64.tar.gz"; dir_name="nvim-linux-x86_64" ;;
    aarch64) asset="nvim-linux-arm64.tar.gz";  dir_name="nvim-linux-arm64" ;;
  esac

  install_tarball_binary \
    "${NVIM_RELEASE_BASE_URL}/${asset}" \
    "$dir_name" \
    "bin/nvim" \
    "nvim"

  echo "    Installed: $(nvim --version | head -n1)"
}

ensure_c_compiler() {
  echo "==> C compiler"
  if command -v cc &>/dev/null || command -v gcc &>/dev/null; then
    echo "    Already installed."
    return
  fi

  echo "    Not found. Installing build-essential..."
  ensure_apt_package build-essential
}

install_tree_sitter() {
  echo "==> tree-sitter-cli (pinned: ${TS_VERSION})"
  local current
  current="$(tree-sitter --version 2>/dev/null | awk '{print $2}' || echo "")"

  if command -v tree-sitter &>/dev/null && [ "$current" = "$TS_VERSION" ]; then
    echo "    Already installed: ${current}"
    return
  fi

  echo "    Installing v${TS_VERSION}..."
  local arch asset
  arch="$(get_arch)"
  case "$arch" in
    x86_64)  asset="tree-sitter-linux-x64.gz" ;;
    aarch64) asset="tree-sitter-linux-arm64.gz" ;;
  esac

  install_gz_binary \
    "${TS_RELEASE_BASE_URL}/${asset}" \
    "tree-sitter"

  echo "    Installed: $(tree-sitter --version)"
}

ensure_ripgrep() {
  echo "==> ripgrep"
  if command -v rg &>/dev/null; then
    echo "    Already installed."
    return
  fi

  echo "    Not found. Installing..."
  ensure_apt_package ripgrep
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
  install_neovim
  ensure_c_compiler
  install_tree_sitter
  ensure_ripgrep
  echo "==> nvim package dependencies satisfied."
}

main
