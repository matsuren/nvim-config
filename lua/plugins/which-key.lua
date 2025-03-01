return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 500
        end,
        opts = {
            layout = {
                width = { min = 30 },
                spacing = 3,
            },
        },
    },
}
