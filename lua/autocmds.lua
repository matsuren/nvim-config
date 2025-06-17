-- Make setting
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.bo.makeprg = "mypy --show-column-numbers --no-error-summary %"
    end,
})
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "make",
    callback = function()
        vim.cmd("cwindow")
    end,
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.swiftinterface" },
    callback = function()
        vim.bo.ft = "swift"
    end,
})

-- Keymap for filetype
-- Kulala
local kulala = require("kulala")
-- Set keymaps only for HTTP and REST filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "http", "rest" },
    callback = function()
        vim.keymap.set("n", "<leader>rb", kulala.scratchpad, { desc = "Open scratchpad", buffer = true })
        vim.keymap.set("n", "<leader>ro", kulala.open, { desc = "Open kulala", buffer = true })
        vim.keymap.set("n", "<leader>rt", kulala.toggle_view, { desc = "Toggle headers/body", buffer = true })
        vim.keymap.set("n", "<leader>rS", kulala.show_stats, { desc = "Show stats", buffer = true })
        vim.keymap.set("n", "<leader>rq", kulala.close, { desc = "Close window", buffer = true })
        vim.keymap.set("n", "<leader>rc", kulala.copy, { desc = "Copy as cURL", buffer = true })
        vim.keymap.set("n", "<leader>rC", kulala.from_curl, { desc = "Paste from curl", buffer = true })
        vim.keymap.set({ "n", "v" }, "<leader>rs", kulala.run, { desc = "Send request", buffer = true })
        vim.keymap.set({ "n", "v" }, "<CR>", kulala.run, { desc = "Send request <cr>", buffer = true })
        vim.keymap.set({ "n", "v" }, "<leader>ra", kulala.run_all, { desc = "Send all requests", buffer = true })
        vim.keymap.set("n", "<leader>ri", kulala.inspect, { desc = "Inspect current request", buffer = true })
        vim.keymap.set("n", "<leader>rr", kulala.replay, { desc = "Replay the last request", buffer = true })
        vim.keymap.set("n", "<leader>rf", kulala.search, { desc = "Find request", buffer = true })
        vim.keymap.set("n", "<leader>rn", kulala.jump_next, { desc = "Jump to next request", buffer = true })
        vim.keymap.set("n", "<leader>rp", kulala.jump_prev, { desc = "Jump to previous request", buffer = true })
        vim.keymap.set("n", "<leader>re", kulala.set_selected_env, { desc = "Select environment", buffer = true })
        vim.keymap.set(
            "n",
            "<leader>rg",
            kulala.download_graphql_schema,
            { desc = "Download GraphQL schema", buffer = true }
        )
        vim.keymap.set("n", "<leader>rx", kulala.scripts_clear_global, { desc = "Clear globals", buffer = true })
        vim.keymap.set("n", "<leader>rX", kulala.clear_cached_files, { desc = "Clear cached files", buffer = true })
    end,
})

-- Handle large file
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    pattern = "*",
    callback = function()
        local file = vim.fn.expand("<afile>")
        local size = vim.fn.getfsize(file)
        local max_filesize = 3 * 1024 * 1024 -- 3 MB

        if size > max_filesize then
            -- -- Disable Treesitter
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = false,
                },
                indent = {
                    enable = false,
                },
                textobjects = {
                    select = {
                        enable = false,
                    },
                },
            })
            -- Disable nvim-cmp
            require("cmp").setup.buffer({ enabled = false })
            -- Disable syntax highlighting
            vim.cmd("syntax off")
            -- Disable some other features
            vim.cmd("set eventignore+=BufRead,BufEnter")
        end
    end,
})

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

-- -- Hover hint from https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--     group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
--     callback = function()
--         vim.diagnostic.config({
--             virtual_text = false,
--         })
--         vim.diagnostic.open_float(nil, { focus = false })
--     end,
-- })

-- Close with q for DAP floating window https://github.com/mfussenegger/nvim-dap/issues/415#issuecomment-2230986168
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-float",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
    end,
})
