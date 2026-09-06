return {
	'nvim-treesitter/nvim-treesitter',
	branch = 'main',
	commit = '857651fce37eba032ebe28f3a206283cdc65c45a',
	lazy = false,
	build = ':TSUpdate',
	config = function()
		local ensure_installed = { 'c', 'cpp', 'go', 'python' }

		require('nvim-treesitter').install(ensure_installed)

		vim.api.nvim_create_autocmd('FileType', {
			pattern = ensure_installed,
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
