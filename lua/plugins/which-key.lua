return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {
            filter = function(mapping)
                return mapping.desc ~= "which_key_ignore"
            end,
            layout = {
                width = { min = 30 },
                spacing = 3,
            },
        },
    },
}
