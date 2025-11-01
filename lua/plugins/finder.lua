return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            "nvim-telescope/telescope-frecency.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local lga_actions = require("telescope-live-grep-args.actions")
            require("telescope").setup({
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({
                            -- even more opts
                        }),
                    },
                    live_grep_args = {
                        auto_quoting = false, -- enable/disable auto-quoting
                        -- define mappings, e.g.
                        mappings = { -- extend mappings
                            i = {
                                ["<C-j>"] = lga_actions.quote_prompt(),
                                ["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                                ["<C-f>"] = require("telescope.actions").to_fuzzy_refine,
                            },
                        },
                    },
                },
                pickers = {
                    buffers = {
                        sort_lastused = true,
                    },
                    find_files = {
                        hidden = true,
                    },
                    grep_string = {
                        additional_args = { "--hidden" },
                    },
                    live_grep = {
                        additional_args = { "--hidden" },
                    },
                },
                defaults = {
                    file_ignore_patterns = {
                        ".cache",
                        ".git/",
                        ".github/",
                    },
                    layout_strategy = "vertical",
                    layout_config = {
                        width = 0.9,
                        height = 0.9,
                        preview_cutoff = 0,
                    },
                    preview = {
                        msg_bg_fillchar = " ",
                    },
                },
            })
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("live_grep_args")
            require("telescope").load_extension("ui-select")
            require("telescope").load_extension("frecency")
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    },
}
