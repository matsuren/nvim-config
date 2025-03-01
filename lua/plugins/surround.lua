return {
    {
        "echasnovski/mini.surround",
        version = "*",
        event = "VeryLazy",
        config = function()
            -- Avoid s -> timeout deletes a character
            vim.keymap.set({ "n", "x" }, "s", "<Nop>")

            require("mini.surround").setup({
                mappings = {
                    add = "sa",
                    replace = "sr",
                    delete = "sd",
                    find = "",
                    find_left = "",
                    highlight = "",
                    update_n_lines = "sn",
                },
            })
        end,
    },
}
