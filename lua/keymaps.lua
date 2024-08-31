-- Basic
-- Save with Ctrl + s
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<Esc>:w<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-s>", "<Esc>:w<CR>gv", { noremap = true, silent = true })

-- Disable F1 help menu
vim.api.nvim_set_keymap("n", "<F1>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<F1>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<F1>", "<Nop>", { noremap = true, silent = true })

-- vim-unimpaired like keymapping
-- Navigate Quickfix List
vim.keymap.set("n", "[q", ":cprevious<CR>", { silent = true, noremap = true, desc = "Previous quickfix item" })
vim.keymap.set("n", "]q", ":cnext<CR>", { silent = true, noremap = true, desc = "Next quickfix item" })
vim.keymap.set("n", "[Q", ":cfirst<CR>", { silent = true, noremap = true, desc = "First quickfix item" })
vim.keymap.set("n", "]Q", ":clast<CR>", { silent = true, noremap = true, desc = "Last quickfix item" })
-- Navigate Location List
vim.keymap.set("n", "[l", ":lprevious<CR>", { silent = true, noremap = true, desc = "Previous location list item" })
vim.keymap.set("n", "]l", ":lnext<CR>", { silent = true, noremap = true, desc = "Next location list item" })
vim.keymap.set("n", "[L", ":lfirst<CR>", { silent = true, noremap = true, desc = "First location list item" })
vim.keymap.set("n", "]L", ":llast<CR>", { silent = true, noremap = true, desc = "Last location list item" })
-- Navigate Buffers
vim.keymap.set("n", "[b", ":bprevious<CR>", { silent = true, noremap = true, desc = "Previous buffer" })
vim.keymap.set("n", "]b", ":bnext<CR>", { silent = true, noremap = true, desc = "Next buffer" })
vim.keymap.set("n", "[B", ":bfirst<CR>", { silent = true, noremap = true, desc = "First buffer" })
vim.keymap.set("n", "]B", ":blast<CR>", { silent = true, noremap = true, desc = "Last buffer" })
-- Navigate Git hunk
vim.keymap.set("n", "[c", "<Cmd>Gitsigns prev_hunk<CR>", { silent = true, noremap = true, desc = "Previous git hunk" })
vim.keymap.set("n", "]c", "<Cmd>Gitsigns next_hunk<CR>", { silent = true, noremap = true, desc = "Next git hunk" })

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
vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Find quickfix" })
vim.keymap.set("n", "<leader>fQ", builtin.quickfixhistory, { desc = "Find quickfix history" })
vim.keymap.set("n", "<leader>fl", builtin.loclist, { desc = "Find loclist" })

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
vim.keymap.set("v", "<leader>cf", function()
    vim.lsp.buf.format({
        async = true,
        range = {
            ["start"] = { vim.fn.line("v"), vim.fn.col("v") - 1 },
            ["end"] = { vim.fn.line("."), vim.fn.col(".") - 1 },
        },
    })
    vim.api.nvim_input("<esc>")
end, { desc = "Code format in selected lines", noremap = true, silent = true })
local function toggle_inlay_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end
vim.keymap.set("n", "<leader>ci", toggle_inlay_hints, { desc = "Toggle inlay hint" })

-- Git
-- vim.keymap.set("n", "<leader>cp", "<Cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Git hunk preview inline" })
vim.keymap.set("n", "<leader>cp", "<Cmd>Gitsigns preview_hunk<CR>", { desc = "Git hunk preview" })
vim.keymap.set("n", "<leader>ct", "<Cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Git toggle line blame" })
vim.keymap.set("n", "<leader>cd", "<Cmd>Gitsigns diffthis<CR>", { desc = "Git diff this (:Gvdiff branch)" })
vim.keymap.set("n", "<leader>cb", "<Cmd>Gitsigns blame<CR>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>cs", "<Cmd>Neogit<CR>", { desc = "Git status with neogit" })
vim.keymap.set("n", "<leader>cl", "<Cmd>0Gclog<CR>", { desc = "Git log for current file" })
vim.keymap.set("n", "<leader>ch", "<Cmd>DiffviewFileHistory %<CR>", { desc = "Git log for current file" })
vim.keymap.set("n", "<leader>cH", "<Cmd>DiffviewFileHistory<CR>", { desc = "Git log for current branch" })

-- Terminal
vim.keymap.set("n", "<leader>tv", "<Cmd>ToggleTerm direction=vertical<CR>", { desc = "Open terminal vertically" })
local Terminal = require("toggleterm.terminal").Terminal
local ipython = Terminal:new({
    cmd = "ipython3",
    direction = "vertical",
})
-- Terminal ipython setting
vim.keymap.set("n", "<leader>tp", function()
    ipython:toggle()
end, { desc = "Open IPython vertically" })
function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
    vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
    vim.keymap.set("n", "<leader>ts", "<Cmd>ToggleTermSendCurrentLine<CR>", { desc = "Send current line to terminal" })
    -- vim.keymap.set("v", "<leader>ts", "<Cmd>ToggleTermSendVisualLines<CR>", { desc = "Send selected line to terminal" })
    vim.keymap.set("v", "<leader>ts", function()
        vim.api.nvim_feedkeys('"+y', "v", true)
        require("toggleterm").exec("%paste", 1)
    end, { desc = "Send @paste to terminal for ipython" })
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
