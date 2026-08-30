-- lua/plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "clangd" },
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- new API: configure, then enable (replaces require("lspconfig").clangd.setup{})
    vim.lsp.config("clangd", {
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
      },
    })
    vim.lsp.enable("clangd")

    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      severity_sort = true,
    })

    -- clangd's custom LSP method for jumping between .cpp <-> .h (Alt+O equivalent)
    local function switch_source_header()
      local clangd_client = vim.lsp.get_clients({ name = "clangd", bufnr = 0 })[1]
      if not clangd_client then
        vim.notify("clangd not attached to this buffer", vim.log.levels.WARN)
        return
      end
      local params = vim.lsp.util.make_text_document_params()
      clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
        if err then
          vim.notify("switchSourceHeader failed: " .. tostring(err), vim.log.levels.ERROR)
          return
        end
        if not result then
          vim.notify("No corresponding source/header found", vim.log.levels.WARN)
          return
        end
        vim.cmd("edit " .. vim.uri_to_fname(result))
      end, 0)
    end

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<M-o>", switch_source_header, opts)
      end,
    })
  end,
}
