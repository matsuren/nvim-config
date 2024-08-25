return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                -- size can be a number or function which is passed the current terminal
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    else
                        return 20
                    end
                end,
                open_mapping = [[<c-_>]], -- Maps Ctrl-/ to open the terminal
                direction = "float",
                float_opts = {
                    border = "curved",
                    winblend = 0,
                },
            })
        end,
    },
}
