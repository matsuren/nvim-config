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
                ensure_installed = {
                    "clangd",
                    "lua_ls",
                    "rust_analyzer",
                    "ruff",
                    "basedpyright",
                    "jsonls",
                    "typos_lsp",
                    "tailwindcss",
                    "gopls",
                },
            })
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
        config = function()
            require("typescript-tools").setup({
                settings = {
                    -- spawn additional tsserver instance to calculate diagnostics on it
                    separate_diagnostic_server = true,
                    -- "change"|"insert_leave" determine when the client asks the server about diagnostic
                    publish_diagnostic_on = "insert_leave",
                    -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
                    -- "remove_unused_imports"|"organize_imports") -- or string "all"
                    -- to include all supported code actions
                    -- specify commands exposed as code_actions
                    expose_as_code_action = {},
                    -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
                    -- not exists then standard path resolution strategy is applied
                    tsserver_path = nil,
                    -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
                    -- (see 💅 `styled-components` support section)
                    tsserver_plugins = {},
                    -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
                    -- memory limit in megabytes or "auto"(basically no limit)
                    tsserver_max_memory = "auto",
                    -- described below
                    tsserver_format_options = {},
                    tsserver_file_preferences = {},
                    -- locale of all tsserver messages, supported locales you can find here:
                    -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
                    tsserver_locale = "en",
                    -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
                    complete_function_calls = false,
                    include_completions_with_insert_text = true,
                    -- CodeLens
                    -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
                    -- possible values: ("off"|"all"|"implementations_only"|"references_only")
                    code_lens = "off",
                    -- by default code lenses are displayed on all referenceable values and for some of you it can
                    -- be too much this option reduce count of them by removing member references from lenses
                    disable_member_code_lens = true,
                    -- JSXCloseTag
                    -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
                    -- that maybe have a conflict if enable this feature. )
                    jsx_close_tag = {
                        enable = false,
                        filetypes = { "javascriptreact", "typescriptreact" },
                    },
                },
            })
        end,
    },
    {
        "luckasRanarison/tailwind-tools.nvim",
        name = "tailwind-tools",
        build = ":UpdateRemotePlugins",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
            "neovim/nvim-lspconfig", -- optional
        },
        opts = {}, -- your configuration
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
            lspconfig.basedpyright.setup({
                capabilities = capabilities,
                settings = {
                    basedpyright = {
                        analysis = {
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
            lspconfig.typos_lsp.setup({})
            lspconfig.gopls.setup({ capabilities = capabilities })
            -- lspconfig.rust_analyzer.setup({ capabilities = capabilities }) -- rustaceanvim handle this part
            -- lspconfig.jsonls.setup({ capabilities = capabilities })
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
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            require("dap.ext.vscode").load_launchjs(nil, { debugpy = { "python" } })
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
            dap.adapters.debugpy = dap.adapters.python

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
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file with arguments",
                    justMyCode = false,
                    console = "integratedTerminal",
                    program = "${file}",
                    pythonPath = pythonPathFn,
                    args = function()
                        -- Prompt the user for arguments
                        local user_input = vim.fn.input("Enter arguments: ")
                        -- Split input into a table of arguments
                        return vim.split(user_input, " ", { trimempty = true })
                    end,
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
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require("nvim-dap-virtual-text").setup({
                enabled = true, -- enable this plugin (the default)
                enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                show_stop_reason = true, -- show stop reason when stopped for exceptions
                commented = true, -- prefix virtual text with comment string
                only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
                all_references = false, -- show virtual text on all all references of the variable (not only definitions)
                clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
                --- A callback that determines how a variable is displayed or whether it should be omitted
                --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
                --- @param buf number
                --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
                --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
                --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
                --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
                display_callback = function(variable, buf, stackframe, node, options)
                    -- by default, strip out new line characters
                    if options.virt_text_pos == "inline" then
                        return " = " .. variable.value:gsub("%s+", " ")
                    else
                        return variable.name .. " = " .. variable.value:gsub("%s+", " ")
                    end
                end,
                -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
                virt_text_pos = "eol",

                -- experimental features:
                all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
                virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
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
}
