return {
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            color = { fg = "#cccccc" },
                        },
                    },
                    lualine_x = {
                        {
                            require("noice").api.statusline.mode.get,
                            cond = require("noice").api.statusline.mode.has,
                            color = { fg = "#ff9e64" },
                        },
                        "encoding",
                        "fileformat",
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {
                        {
                            "filename",
                            path = 3,
                            color = { fg = "#bbbbbb" },
                        },
                    },
                    lualine_x = {
                        {
                            "encoding",
                            color = { fg = "#aaaaaa" },
                        },
                        {
                            "fileformat",
                            color = { fg = "#aaaaaa" },
                        },
                        {
                            "filetype",
                            color = { fg = "#aaaaaa" },
                        },
                        {
                            "location",
                            color = { fg = "#aaaaaa" },
                        },
                    },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {
                    lualine_a = { { "buffers", mode = 4 } },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { "tabs" },
                },
                winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    -- lualine_c = {
                    --     {
                    --         "filename",
                    --         path = 3,
                    --     },
                    -- },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },

                inactive_winbar = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    -- lualine_c = {
                    --     {
                    --         "filename",
                    --         path = 3,
                    --     },
                    -- },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {},
                },
                extensions = {},
            })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            local ibl = require("ibl")
            ibl.setup({
                scope = {
                    enabled = false,
                },
            })
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup({
                user_default_options = {
                    RGB = false, -- Disable #123
                    names = false, -- Disable Red, Blue, etc.
                },
            })
        end,
    },
    {
        -- Loading ui on bottom right
        "j-hui/fidget.nvim",
        opts = {
            -- options
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                messages = {
                    -- Use kevinhwang91/nvim-hlslens for search count otherwise max_count is 99
                    view_search = false,
                },
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true, -- add a border to hover docs and signature help
                },
            })
        end,
    },
    {
        "kevinhwang91/nvim-hlslens",
        dependencies = { "haya14busa/vim-asterisk" },
        config = function()
            -- Setup hlslens
            require("hlslens").setup()
            -- Key mappings with asterisk and hlslens integration
            -- Normal mode mappings
            vim.keymap.set(
                "n",
                "*",
                '<Plug>(asterisk-z*)<Cmd>lua require("hlslens").start()<CR>',
                { desc = "Search forward with asterisk", silent = true }
            )
            vim.keymap.set(
                "n",
                "#",
                '<Plug>(asterisk-z#)<Cmd>lua require("hlslens").start()<CR>',
                { desc = "Search backward with asterisk", silent = true }
            )
            vim.keymap.set(
                "n",
                "g*",
                '<Plug>(asterisk-gz*)<Cmd>lua require("hlslens").start()<CR>',
                { desc = "Search forward (substring) with asterisk", silent = true }
            )
            vim.keymap.set(
                "n",
                "g#",
                '<Plug>(asterisk-gz#)<Cmd>lua require("hlslens").start()<CR>',
                { desc = "Search backward (substring) with asterisk", silent = true }
            )

            -- Visual mode mappings
            vim.keymap.set(
                "x",
                "*",
                '<Plug>(asterisk-z*)<Cmd>lua require("hlslens").start()<CR>',
                { desc = "Search forward (visual) with asterisk", silent = true }
            )
            vim.keymap.set(
                "x",
                "#",
                '<Plug>(asterisk-z#)<Cmd>lua require("hlslens").start()<CR>',
                { desc = "Search backward (visual) with asterisk", silent = true }
            )
            vim.keymap.set(
                "x",
                "g*",
                '<Plug>(asterisk-gz*)<Cmd>lua require("hlslens").start()<CR>',
                { desc = "Search forward (substring, visual) with asterisk", silent = true }
            )
            vim.keymap.set(
                "x",
                "g#",
                '<Plug>(asterisk-gz#)<Cmd>lua require("hlslens").start()<CR>',
                { desc = "Search backward (substring, visual) with asterisk", silent = true }
            )
        end,
    },
}
