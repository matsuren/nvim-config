return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
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
                    "markdown_inline",
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
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
    {
        "williamboman/mason.nvim",
        config = function()
            local configs = require("mason")
            configs.setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "rust_analyzer" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.rust_analyzer.setup({})
        end,
    },
}
