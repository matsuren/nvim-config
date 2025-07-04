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
            -- https://github.com/nvim-lualine/lualine.nvim/pull/1296
            function shorten_str(str, len)
                if string.len(str) > len then
                    return string.sub(str, 1, len / 2) .. "…" .. string.sub(str, str:len() - len / 2 + 1, str:len())
                else
                    return str
                end
            end

            require("lualine").setup({
                options = {
                    component_separators = "|",
                    section_separators = "",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        {
                            "branch",
                            fmt = function(str)
                                return shorten_str(str, 20)
                            end,
                            icons_enabled = false,
                        },
                        "diff",
                        -- "diagnostics",
                    },
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
                        { "filetype", icons_enabled = false },
                    },
                    lualine_y = { "progress" },
                    lualine_z = { { "location", padding = { left = 0, right = 1 } } },
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
                            "filetype",
                            icons_enabled = false,
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
                    lualine_y = {
                        function()
                            return vim.fn.getcwd()
                        end,
                    },
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
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
            require("colorizer").setup({
                user_default_options = {
                    RGB = false, -- Disable #123
                    names = false, -- Disable Red, Blue, etc.
                    tailwind = "normal",
                    always_update = true, -- Good for tailwind cmp_menu
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
            {
                "rcarriga/nvim-notify",
                config = function()
                    require("notify").setup({
                        max_width = 50,
                        timeout = 1000,
                        render = "wrapped-compact",
                        stages = "fade",
                    })
                end,
            },
        },
        config = function()
            require("noice").setup({
                views = {
                    hover = {
                        view = "popup",
                        relative = "cursor",
                        anchor = "auto",
                        size = {
                            width = "auto",
                            height = "auto",
                            max_height = 20,
                            max_width = 80,
                        },
                        border = {
                            style = "rounded",
                            padding = { 0, 1 },
                        },
                        position = { row = 0, col = 10 },
                        win_options = {
                            wrap = true,
                            linebreak = true,
                        },
                    },
                },
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
                    signature = {
                        relative = "cursor",
                        auto_open = {
                            throttle = 500,
                        },
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
    {
        -- Hightligt and StripWhitespace
        "ntpeters/vim-better-whitespace",
    },
}
