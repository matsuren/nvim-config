-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recently open files" })
vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "Find jumplist" })
vim.keymap.set("n", "<leader>fc", builtin.git_status, { desc = "Find changes" })
vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Find marks" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })

--  File explore
vim.keymap.set("n", "<leader>fe", "<Cmd>Neotree toggle<CR>", { desc = "File explore" })
vim.keymap.set("n", "<leader>fo", "<Cmd>Oil --float<CR>", { desc = "Open parent directory" })

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go declaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go reference" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Code format" })

-- Git
-- vim.keymap.set("n", "<leader>gp", "<Cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Git hunk preview inline" })
vim.keymap.set("n", "<leader>gp", "<Cmd>Gitsigns preview_hunk<CR>", { desc = "Git hunk preview" })
vim.keymap.set("n", "<leader>gt", "<Cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Git toggle line blame" })
vim.keymap.set("n", "<leader>gd", "<Cmd>Gitsigns diffthis<CR>", { desc = "Git diff this (:Gvdiff branch)" })

