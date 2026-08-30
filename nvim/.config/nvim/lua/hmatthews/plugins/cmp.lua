-- lua/plugins/cmp.lua
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter", -- lazy-loads on insert, matches when cmp-nvim-lsp needs it
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- you already have this; listed here too for clarity
    "hrsh7th/cmp-buffer",   -- suggestions from current buffer text
    "hrsh7th/cmp-path",     -- filesystem path completion
    "L3MON4D3/LuaSnip",     -- snippet engine
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- clangd suggestions, highest priority
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
    })
  end,
}
