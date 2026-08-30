return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")
    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },

        -- Add mappings inside Telescopes prompt mode
        mappings = {
            i = { -- Insert mode (typing in the search bar)
                ["<Tab>"] = actions.move_selection_next,
                ["<S-Tab>"] = actions.move_selection_previous,
                ["<C-v>"] = actions.select_vertical,
                ["<C-x>"] = actions.select_horizontal,
                ["<CR>"]  = actions.select_default,
                ["<C-c>"] = actions.close,
            },
            n = { -- Normal mode inside Telescope window
                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["v"] = actions.select_vertical,
                ["s"] = actions.select_horizontal,
                ["q"] = actions.close,
            },
        },
      },
    })

    -- Keymaps for Telescope
    local keymap = vim.keymap.set
    local opts = function(desc)
      return { noremap = true, silent = true, desc = desc }
    end

    keymap("n", "<leader><space>", builtin.find_files, opts("Find files in project"))
    keymap("n", "<leader>fg", builtin.live_grep, opts("Search text across project (grep)"))
    keymap("n", "<leader>fb", builtin.buffers, opts("Search active open buffers"))
    keymap("n", "<leader>fh", builtin.help_tags, opts("Search NeoVim help documentation"))
  end,
}
