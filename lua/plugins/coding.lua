return {
{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup(
            {
                ensure_installed = {
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "go",
                    "cmake",
                    "python",
                    "rust",
                    "javascript",
                    "html",
                    "arduino",
                    "markdown",
                    "markdown_inline"
                },
                sync_install = false,
                highlight = {enable = true},
                indent = {enable = true}
            }
        )
    end
},
{
	"lewis6991/gitsigns.nvim",
	version = "0.9.0",
	config = true,
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
}
