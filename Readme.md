# dotfiles

Personal configuration managed with [GNU Stow](https://www.gnu.org/software/stow/) and bootstrapped with a single script.

## Included

| Package | Contains |
|---|---|
| `git/` | `.gitconfig` |
| `nvim/` | Neovim config |
| `zsh/` | `.zshrc`, modular `.zsh/` scripts, Oh My Zsh |

## Install

```bash
cd <path-to-repo>/dotfiles
chmod +755 install.sh
./install.sh
```

This installs GNU Stow (if missing), installs each package's own dependencies, and symlinks everything into `$HOME`. Safe to re-run any time — every step checks before it acts.

## Clean (Uninstall)

```bash
cd <path-to-repo>/dotfiles
chmod +755 uninstall.sh
./uninstall.sh
```

Removes every symlink this repo created from `$HOME`, cleanly -- run this **before** deleting the repo. Deleting the repo first leaves broken symlinks behind, since nothing else knows to clean them up.
Note: This only removes the dotfiles links, not the tools themselves.`

## Adding a new package

1. `mkdir <tool>` and mirror the real target path inside it (e.g. `tool/.config/tool/...`)
2. Optionally add `tool/install.sh` to install that tool and its dependencies (see `nvim/install.sh` for the pattern)
3. `stow --no-folding <tool>` — or just re-run `./install.sh`, which picks up new packages automatically
