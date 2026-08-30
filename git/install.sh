#!/usr/bin/env bash
#
# Installs git itself if it isn't already present.

set -euo pipefail

echo "==> git"
if command -v git &> /dev/null; then
  echo "    Already installed: $(git --version)"
else
  echo "    Not found. Installing..."
  sudo apt update
  sudo apt install -y git
fi

echo "==> git package dependencies satisfied."
