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
./install.sh
```

Installs GNU Stow (if missing), installs each package's own dependencies, and symlinks everything into `$HOME`. Safe to re-run any time — every step checks before it acts.

To install or re-stow a specific package only:

```bash
./install.sh nvim         # one package
./install.sh nvim zsh     # multiple packages
```

## Clean (Uninstall)

```bash
cd <path-to-repo>/dotfiles
./clean.sh
```

Removes every symlink this repo created from `$HOME`, cleanly — run this **before** deleting the repo. Deleting the repo first leaves broken symlinks behind, since nothing else knows to clean them up.

Note: this only removes the dotfile links, not the tools themselves.

## Pinned versions

Neovim and tree-sitter-cli are downloaded at explicit versions defined at the top of `nvim/install.sh`:

| Variable | Tool |
|---|---|
| `NVIM_VERSION` | Neovim |
| `TS_VERSION` | tree-sitter-cli |

To upgrade either tool, bump the variable and re-run:

```bash
./install.sh nvim
```

The script detects the version mismatch and reinstalls automatically.

## Adding a new package

1. `mkdir <tool>` and mirror the real target path inside it (e.g. `tool/.config/tool/...`)
2. Optionally add `tool/install.sh` to install that tool and its dependencies (see `nvim/install.sh` for the pattern)
3. `stow --no-folding <tool>` — or just re-run `./install.sh`, which picks up new packages automatically
