return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- Adds file icons next to buffer names
    },
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers",                    -- Displays open buffers, not vim tabs
                diagnostics = "nvim_lsp",            -- Shows LSP diagnostics errors/warnings in tabs
                always_show_bufferline = true,
                separator_style = "slant",           -- UI style: "slant" | "slope" | "thick" | "thin"
            },
        })

        local map = vim.keymap.set

        -- Reorder: move current buffer left/right one position at a time
        map("n", "<leader>bmn", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer next" })
        map("n", "<leader>bmp", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer prev" })

        -- Bulk sort
        map("n", "<leader>bse", "<cmd>BufferLineSortByExtension<cr>", { desc = "Sort by extension" })
        map("n", "<leader>bsd", "<cmd>BufferLineSortByDirectory<cr>", { desc = "Sort by directory" })

        -- Jump-to-buffer by letter (bufferline assigns a target letter per tab)
        map("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })

        -- Close current buffer without closing the window/split
        map("n", "<leader>bc", "<cmd>bdelete<cr>", { desc = "Close buffer" })

    end,
}
