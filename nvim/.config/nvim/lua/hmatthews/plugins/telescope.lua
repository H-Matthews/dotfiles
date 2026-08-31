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

    keymap("n", "<leader>ff", builtin.find_files, opts("Find files in project"))
    keymap("n", "<leader>fg", function() builtin.live_grep({ grep_open_files = true }) end, opts("Grep open files"))
    keymap("n", "<leader>fp", builtin.live_grep, opts("Grep Project"))
    keymap("n", "<leader>fh", builtin.help_tags, opts("Find NeoVim help documentation"))
    keymap("n", "<leader>fr", builtin.oldfiles, opts("Find recent files"))
    keymap("n", "<leader>fs", builtin.grep_string, opts("Find string under cursor"))
    keymap("n", "<leader>fd", builtin.diagnostics, opts("Find diagnostics"))
    keymap("n", "<leader>fc", builtin.git_commits, opts("Find git commits"))

    keymap("n", "<leader><leader>", builtin.buffers, opts("Quick Switch Buffer"))
  end,
}
