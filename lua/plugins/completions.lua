return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-cmdline",
            "ray-x/cmp-treesitter",
            "lukas-reineke/cmp-rg",
            {
                "windwp/nvim-autopairs",
                event = "InsertEnter",
                config = function()
                    require("nvim-autopairs").setup({})
                end,
            },
            {
                "L3MON4D3/LuaSnip",
                config = function()
                    require("luasnip").setup({})
                    require("luasnip.loaders.from_vscode").lazy_load()
                    require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
                end,
                dependencies = { "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets" },
            },
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "rg", keyword_length = 4, max_item_count = 4 },
                    { name = "treesitter", keyword_length = 4, max_item_count = 4 },
                    {
                        name = "buffer",
                        keyword_length = 4,
                        option = {
                            get_bufnrs = function()
                                local buf = vim.api.nvim_get_current_buf()
                                local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
                                if byte_size > 1024 * 1024 then -- 1 Megabyte max
                                    return {}
                                end
                                return { buf }
                            end,
                        },
                    },
                    { name = "path", keyword_length = 3 },
                    { name = "vim-dadbod-completion" },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        -- Source
                        vim_item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            treesitter = "[Tree]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                            rg = "[Rg]",
                            ["vim-dadbod-completion"] = "[DB]",
                        })[entry.source.name]
                        vim_item.dup = ({
                            nvim_lsp = 0,
                            luasnip = 1,
                        })[entry.source.name] or 0
                        return vim_item
                    end,
                },
                performance = {
                    max_view_entries = 30,
                },
                experimental = { ghost_text = true },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })
        end,
    },
}
