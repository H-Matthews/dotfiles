# Neovim Configuration

Personal Neovim setup built on [lazy.nvim](https://github.com/folke/lazy.nvim)

## Requirements

- **Neovim 0.12+**
- **C Compiler** (gcc or clang) -- required to build treesitter parsers
- [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter) **0.26.1+** -- install via  prebuilt binary from the [release page](https://github.com/tree-sitter/tree-sitter/releases), The version in most package managers (e.g. 'apt') is too old
- [ripgrep](https://github.com/BurntSushi/ripgrep) -- Used by Telescopes live grep
- **[Nerd Font](https://www.nerdfonts.com/)** -- for file-type icons

## Installation

```bash
git clone H-Matthews/nvim-config ~/.config/nvim
nvim
```

`lazy.nvim` bootstraps itself and installs all plugins automatically on first launch. After plugins finish instlaling, run `:TSInstall <language>` for any parsers you need (e.g. `c`, `cpp`, `go`, `python`, `lua`)

## Notes

- Treesitter parsers are compiled binaries tied to your macine's architecture and `tree-sitter-cli` version -- if you move this config to a new machine, make sure `tree-sitter-cli` (0.26.1+) and a C compilers installed
