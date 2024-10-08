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
                    "html",
                    "arduino",
                    "markdown",
                    "markdown_inline",
                    "json",
                    "xml",
                },
                auto_install = true,
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
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
                ensure_installed = { "clangd", "lua_ls", "rust_analyzer", "ruff", "pyright", "jsonls" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            -- PlatformIO setting
            lspconfig.clangd.setup({
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--query-driver="
                        .. os.getenv("HOME")
                        .. "/.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-g*",
                },
                filetypes = { "c", "cpp" },
            })
            lspconfig.ruff.setup({ capabilities = capabilities })
            lspconfig.pyright.setup({ capabilities = capabilities })
            -- lspconfig.rust_analyzer.setup({ capabilities = capabilities }) -- rustaceanvim handle this part
            lspconfig.jsonls.setup({ capabilities = capabilities })
            vim.lsp.inlay_hint.enable(true)
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
        lazy = false, -- This plugin is already lazy
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            vim.cmd([[highlight DapBreakpointTextHl guifg=#DD0000]])
            vim.cmd([[highlight DapStoppedTextHl guifg=#00DD00]])
            vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DapBreakpointTextHl" })
            vim.fn.sign_define("DapStopped", { text = ">", texthl = "DapStoppedTextHl" })

            -- Python adapter configuration
            dap.adapters.python = function(cb, config)
                if config.request == "attach" then
                    local port = (config.connect or config).port
                    local host = (config.connect or config).host or "127.0.0.1"
                    cb({
                        type = "server",
                        port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                        host = host,
                        options = {
                            source_filetype = "python",
                        },
                    })
                else
                    cb({
                        type = "executable",
                        command = "python",
                        args = { "-m", "debugpy.adapter" },
                        options = {
                            source_filetype = "python",
                        },
                    })
                end
            end

            -- Python launch configuration
            local pythonPathFn = function()
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                    return cwd .. "/venv/bin/python"
                elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                    return cwd .. "/.venv/bin/python"
                else
                    return "python"
                end
            end
            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    justMyCode = false,
                    console = "integratedTerminal",
                    program = "${file}",
                    pythonPath = pythonPathFn,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file (justMyCode=true)",
                    justMyCode = true,
                    console = "integratedTerminal",
                    program = "${file}",
                    pythonPath = pythonPathFn,
                },
            }
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            "folke/neodev.nvim",
        },
        config = function()
            -- For more information, see |:help nvim-dap-ui|
            require("dapui").setup({
                -- Set icons to characters that are more likely to work in every terminal.
                --    Feel free to remove or use ones that you like more! :)
                --    Don't feel like these are good choices.
                icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
                controls = {
                    icons = {
                        pause = "⏸",
                        play = "▶",
                        step_into = "⏎",
                        step_over = "⏭",
                        step_out = "⏮",
                        step_back = "b",
                        run_last = "▶▶",
                        terminate = "⏹",
                        disconnect = "⏏",
                    },
                },
            })
            require("neodev").setup({
                library = {
                    plugins = { "nvim-dap-ui" },
                    types = true,
                },
            })
        end,
    },
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python", --optional
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        lazy = false,
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            require("venv-selector").setup()
        end,
        keys = {
            { "<leader>cv", "<cmd>VenvSelect<cr>" },
        },
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
            { "ibhagwan/fzf-lua" }, --optional: if you want to use fzf-lua to pick scratch file. Recommanded, since it will order the files by modification datetime desc. (require rg)
            -- { "nvim-telescope/telescope.nvim" }, -- optional: if you want to pick scratch file by telescope
            -- { "stevearc/dressing.nvim" }, -- optional: to have the same UI shown in the GIF
        },
        config = function()
            require("scratch").setup({
                scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim", -- where your scratch files will be put
                window_cmd = "rightbelow vsplit", -- 'vsplit' | 'split' | 'edit' | 'tabedit' | 'rightbelow vsplit'
                use_telescope = true,
                -- fzf-lua is recommanded, since it will order the files by modification datetime desc. (require rg)
                file_picker = "fzflua", -- "fzflua" | "telescope" | nil
                filetypes = { "py", "lua", "js", "sh", "ts" }, -- you can simply put filetype here
            })
        end,
    },
}
