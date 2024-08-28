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
    command = "checktime",
})
