return {
{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        {
            's1n7ax/nvim-window-picker',
            version = '2.*',
            config = function()
                require 'window-picker'.setup({
                    filter_rules = {
                        include_current_win = false,
                        autoselect_one = true,
                        -- filter using buffer options
                        bo = {
                            -- if the file type is one of following, the window will be ignored
                            filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                            -- if the buffer type is one of following, the window will be ignored
                            buftype = { 'terminal', "quickfix" },
                        },
                },
            })
            end,
        },
    },
    config = function()
        local configs =
            require("neo-tree").setup(
            {
                source_selector = {
                    winbar = true,
                    statusline = true
                },
                window = {
                    mappings = {
                        ["P"] = {"toggle_preview", config = {use_float = true, use_image_nvim = true}}
                    },
                    width = 30,
                },
                filesystem = {
                    filtered_items = {hide_dotfiles = false},
                    hijack_netrw_behavior = "open_default",
                }
            }
        )
    end
}}
