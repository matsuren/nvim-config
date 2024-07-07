return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = {"nvim-lua/plenary.nvim"},
        config = function()
            local configs =
                require("telescope").setup(
                {
                    extensions = {
                        fzf = {
                            fuzzy = true, -- false will only do exact matching
                            override_generic_sorter = true, -- override the generic sorter
                            override_file_sorter = true, -- override the file sorter
                            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
                            -- the default case_mode is "smart_case"
                        }
                    },
                    defaults = {
                        layout_strategy = 'vertical',
                        layout_config = {
                            width = 0.9,
                            height = 0.9,
                            preview_cutoff = 0,
                        },
                        preview = {
                            msg_bg_fillchar = " ",
                        }
                    }
                }
            )
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
    }
}
