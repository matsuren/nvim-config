return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            {
                "nvim-treesitter/nvim-treesitter-context",
                config = function()
                    require("treesitter-context").setup({
                        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                        max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
                        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                        multiline_threshold = 20, -- Maximum number of lines to show for a single context
                        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
                    })
                end,
            },
        },
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
                    "typescript",
                    "html",
                    "arduino",
                    "markdown",
                    "markdown_inline",
                    "json",
                    "xml",
                    "comment",
                },
                auto_install = true,
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = false }, -- Doesn't work for tsx
                textobjects = {
                    select = {
                        enable = true,
                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,
                        keymaps = {
                            ["af"] = { query = "@function.outer", desc = "Select outer part of a function" },
                            ["if"] = { query = "@function.inner", desc = "Select inner part of a function" },
                            ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                        },
                    },
                    swap = {
                        enable = false,
                    },
                    move = {
                        enable = false,
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        version = "^2.0.0",
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
        "mason-org/mason-lspconfig.nvim",
        version = "^2.0.0",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                automatic_enable = false,
                ensure_installed = {
                    "typos_lsp",
                },
            })
        end,
    },
    {
        "windwp/nvim-ts-autotag",
        event = { "BufNewFile", "BufReadPre" },
        config = function()
            require("nvim-ts-autotag").setup({
                opts = {
                    -- Defaults
                    enable_close = true, -- Auto close tags
                    enable_rename = true, -- Auto rename pairs of tags
                    enable_close_on_slash = false, -- Auto close on trailing </
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- PlatformIO setting
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--query-driver="
                        .. os.getenv("HOME")
                        .. "/.platformio/packages/toolchain-riscv32-esp/bin/riscv32-esp-elf-g*",
                },
                filetypes = { "c", "cpp" },
            })
            vim.lsp.config("ruff", {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- Disable hover in favor of Pyright
                    client.server_capabilities.hoverProvider = false
                end,
            })
            vim.lsp.config("basedpyright", {
                capabilities = capabilities,
                settings = {
                    basedpyright = {
                        analysis = {
                            -- Ignore all files for analysis to exclusively use Ruff for linting
                            ignore = { "*" },
                            --
                            typeCheckingMode = "off", -- "off", "basic", "standard", "strict", "recommended", "all"
                            autoImportCompletions = false,
                            diagnosticSeverityOverrides = {
                                reportTypeCommentUsage = "none",
                                -- Use ruff instead of the following
                                reportUnusedImport = "none",
                                reportUnusedVariable = "none",
                            },
                            inlayHints = {
                                variableTypes = true,
                                functionReturnTypes = true,
                                pytestParameters = true,
                                callArgumentNames = true,
                            },
                        },
                    },
                },
            })
            vim.lsp.config("biome", { capabilities = capabilities })
            vim.lsp.config("typos_lsp", {})
            vim.lsp.config("gopls", { capabilities = capabilities })
            vim.lsp.config("zls", { capabilities = capabilities })
            -- lspconfig.rust_analyzer.setup({ capabilities = capabilities }) -- rustaceanvim handle this part
            -- lspconfig.jsonls.setup({ capabilities = capabilities })
            vim.lsp.config("graphql", { capabilities = capabilities })
            if vim.loop.os_gethostname() == "ren-thinkpad" then
                vim.lsp.enable({ "typos_lsp", "ruff", "basedpyright", "biome", "gopls" })
            else
                vim.lsp.enable({ "typos_lsp", "ruff", "basedpyright", "biome" })
            end
            vim.lsp.inlay_hint.enable(true)
            local base_severity = vim.diagnostic.severity.HINT
            vim.diagnostic.config({
                -- Check keymap for cycling diagnostic severity levels
                underline = {
                    severity = { min = base_severity },
                },
                virtual_text = {
                    source = "always",
                    severity = { min = base_severity },
                },
                signs = { priority = 10 },
                float = {
                    border = "rounded",
                    source = "always",
                },
                update_in_insert = false,
                severity_sort = true,
            })
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
        lazy = false, -- This plugin is already lazy
    },
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        ft = "python",
        keys = {
            { "<leader>cv", "<cmd>VenvSelect<cr>" },
        },
        opts = {},
    },
    {
        "stevearc/aerial.nvim",
        opts = {},
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("aerial").setup({
                -- optionally use on_attach to set keymaps when aerial has attached to a buffer
                on_attach = function(bufnr)
                    -- Navigate Outline by aerial.nivm
                    vim.keymap.set(
                        "n",
                        "[o",
                        ":AerialPrev<CR>",
                        { buffer = bufnr, silent = true, noremap = true, desc = "Previous outline item" }
                    )
                    vim.keymap.set(
                        "n",
                        "]o",
                        ":AerialNext<CR>",
                        { buffer = bufnr, silent = true, noremap = true, desc = "Next Outline item" }
                    )
                end,
                layout = { default_direction = "prefer_left" },
                highlight_on_jump = false,
                -- Disable aerial on files with this many lines
                disable_max_lines = 10000,
                -- Disable aerial on files this size or larger (in bytes)
                disable_max_size = 2000000, -- Default 2MB
                -- A list of all symbols to display. Set to false to display all symbols.
                -- This can be a filetype map (see :help aerial-filetype-map)
                -- To see all available values, see :help SymbolKind
                filter_kind = {
                    "Class",
                    "Constructor",
                    "Enum",
                    "Function",
                    "Interface",
                    "Module",
                    "Method",
                    "Struct",
                    "Key",
                    "Array",
                },
            })
        end,
    },
    {
        "LintaoAmons/scratch.nvim",
        event = "VeryLazy",
        dependencies = {
            { "ibhagwan/fzf-lua" }, --optional: if you want to use fzf-lua to pick scratch file. Recommended, since it will order the files by modification datetime desc. (require rg)
            -- { "nvim-telescope/telescope.nvim" }, -- optional: if you want to pick scratch file by telescope
            -- { "stevearc/dressing.nvim" }, -- optional: to have the same UI shown in the GIF
        },
        config = function()
            require("scratch").setup({
                scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim", -- where your scratch files will be put
                window_cmd = "rightbelow vsplit", -- 'vsplit' | 'split' | 'edit' | 'tabedit' | 'rightbelow vsplit'
                use_telescope = true,
                -- fzf-lua is recommended, since it will order the files by modification datetime desc. (require rg)
                file_picker = "fzflua", -- "fzflua" | "telescope" | nil
                filetypes = { "py", "lua", "js", "sh", "ts" }, -- you can simply put filetype here
            })
        end,
    },
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>xs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xq",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        "Davidyz/inlayhint-filler.nvim",
    },
    {
        "andythigpen/nvim-coverage",
        version = "*",
        config = function()
            require("coverage").setup({
                auto_reload = true,
                load_coverage_cb = function(ftype)
                    vim.notify("Loaded " .. ftype .. " coverage")
                end,
            })
        end,
    },
    {
        "sakhnik/nvim-gdb",
    },
}
