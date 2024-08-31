vim.api.nvim_create_augroup("custom_buffer", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = custom_buffer,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 150 })
    end,
})

vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    command = "silent! checktime",
})

-- Handle insert mode apearing issue
-- https://github.com/nvim-telescope/telescope.nvim/issues/2766
vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
        end
    end,
})
