return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 500,
				},
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
			})
		end,
	},
	{
		"rhysd/committia.vim",
		lazy = false,
		ft = "gitcommit",
		config = function()
			vim.g.committia_min_window_width = 140
			vim.g.committia_edit_window_width = 90
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = true,
	},
	{
		"tpope/vim-fugitive",
	},
}
