return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                current_line_blame = true,
                current_line_blame_opts = {
                    delay = 500,
                },
                max_file_length = 100000, -- Disable if file is longer than this (in lines)
                sign_priority = 100,
                on_attach = function(bufnr)
                    local gitsigns = require("gitsigns")

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map("n", "[c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "[c", bang = true })
                        else
                            gitsigns.nav_hunk("prev")
                        end
                    end, { desc = "Previous git hunk" })
                    map("n", "]c", function()
                        if vim.wo.diff then
                            vim.cmd.normal({ "]c", bang = true })
                        else
                            gitsigns.nav_hunk("next")
                        end
                    end, { desc = "Next git hunk" })
                end,
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
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup({
                enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
            })
        end,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local neogit = require("neogit")
            neogit.setup({
                disable_insert_on_commit = true,
            })
        end,
    },
    {
        "tpope/vim-fugitive",
    },
}
