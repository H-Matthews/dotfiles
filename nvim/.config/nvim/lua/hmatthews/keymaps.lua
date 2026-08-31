local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Helper function for generating options with custom description for Which-Key
local function opts(desc)
    return { noremap = true, silent = true, desc = desc }
end

-- General & File Management
keymap("n", "<leader>w", ":w<CR>", opts("Save file"))
keymap("n", "<leader>q", ":q<CR>", opts("Quit Window"))
keymap("n", "<leader>h", ":nohlsearch<CR>", opts("Clear search highlight"))
keymap("n", "<leader>uw", function() vim.opt.list = not vim.opt.list:get() end, opts("Toggle whitespace chars"))

-- Easy Window Navigation (Ctrl + h/j/k/l)
keymap("n", "<C-h>", "<C-w>h", opts("Move focus to left split"))
keymap("n", "<C-j>", "<C-w>j", opts("Move focus to lower split"))
keymap("n", "<C-k>", "<C-w>k", opts("Move focus to upper split"))
keymap("n", "<C-l>", "<C-w>l", opts("Move focus to right split"))

-- Window Splitting
keymap("n", "<leader>sv", ":vsplit<CR>", opts("Split window vertically"))
keymap("n", "<leader>sh", ":split<CR>", opts("Split window horizontally"))
keymap("n", "<leader>se", "<C-w>=", opts("Make split sizes equal"))

-- Window Resizing
keymap("n", "<C-Up", ":resize -2<CR>", opts("Decrease window height"))
keymap("n", "<C-Down", ":resize +2<CR>", opts("Increase window height"))
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts("Decrease window width"))
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts("Increase window width"))

-- Buffer Management & Navigation
keymap("n", "<S-h>", ":bprevious<CR>", opts("Switch to previous buffer"))
keymap("n", "<S-l>", ":bnext<CR>", opts("Switch to next buffer"))
keymap("n", "<leader>bd", ":bdelete<CR>", opts("Close active buffer"))

-- Visual Mode Manipulation
keymap("v", "<", "<gv", opts("Indent selection left (keep visual zone)"))
keymap("v", ">", ">gv", opts("Indent selection right (keep visual zone)"))
keymap("v", "J", ":m '>+1<CR>gv=gv", opts("Move Selected lines down"))
keymap("v", "K", ":m '<-2<CR>gv=gv", opts("Move Selected lines up"))

-- Viewport & Search Centering
keymap("n", "<C-d>", "<C-d>zz", opts("Scroll half-page down (centered)"))
keymap("n", "<C-u>", "<C-u>zz", opts("Scroll half-page up (centered)"))
keymap("n", "n", "nzzzv", opts("Next search result (centered)"))
keymap("n", "N", "Nzzzv", opts("Prev search result (centered)"))
