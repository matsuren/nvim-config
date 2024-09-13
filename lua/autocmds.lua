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

-- Hover hint from https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
    callback = function()
        vim.diagnostic.config({
            virtual_text = false,
        })
        vim.diagnostic.open_float(nil, { focus = false })
    end,
})

-- Close with q for DAP floating window https://github.com/mfussenegger/nvim-dap/issues/415#issuecomment-2230986168
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-float",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
    end,
})
