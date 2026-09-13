return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            vim.keymap.set("n", "<leader>tv", "<Cmd>ToggleTerm direction=vertical<CR>", {
                desc = "Open terminal vertically",
            })
            vim.api.nvim_create_autocmd("TermOpen", {
                group = vim.api.nvim_create_augroup("TerminalKeymaps", { clear = true }),
                callback = function(event)
                    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = event.buf })
                    for _, direction in ipairs({ "h", "j", "k", "l" }) do
                        vim.keymap.set("t", "<C-" .. direction .. ">", [[<C-\><C-n><C-w>]] .. direction, {
                            buffer = event.buf,
                        })
                    end
                end,
            })
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
                open_mapping = nil,
            })
        end,
    },
}
