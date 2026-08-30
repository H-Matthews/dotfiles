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
    end,
}
