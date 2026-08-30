-- Enable line numbers and relative line numbers for fast jumping
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation Settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- UI & Search quality of life
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

-- Set spacebar as leader key
vim.g.mapleader = " "

-- Turn off netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable standard filetype detection and syntax highlighting in Neovim core
vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

