return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300   -- Popup appears after 300ms pause
    end,
    opts = {
        -- Uses default configuration settings
    },
}
