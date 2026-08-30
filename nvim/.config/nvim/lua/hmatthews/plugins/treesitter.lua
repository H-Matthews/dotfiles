vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'go', 'python' },
    callback = function() vim.treesitter.start() end,
})

return {
	'nvim-treesitter/nvim-treesitter',
	branch = 'main',
	lazy = false,
	build = ':TSUpdate',
}
