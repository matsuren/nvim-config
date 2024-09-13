return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            layout = {
                width = { min = 30 },
                spacing = 3,
            },
        },
    },
}
