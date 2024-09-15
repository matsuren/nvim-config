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
-- Navigate Tabs
vim.keymap.set("n", "[t", ":tabprevious<CR>", { silent = true, noremap = true, desc = "Previous tab" })
vim.keymap.set("n", "]t", ":tabnext<CR>", { silent = true, noremap = true, desc = "Next tab" })
vim.keymap.set("n", "[T", ":tabfirst<CR>", { silent = true, noremap = true, desc = "First tab" })
vim.keymap.set("n", "]T", ":tablast<CR>", { silent = true, noremap = true, desc = "Last tab" })

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
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find symbols via lsp" })

--  File explore
vim.keymap.set("n", "<leader>fe", "<Cmd>Neotree toggle<CR>", { desc = "File explore" })
vim.keymap.set("n", "<leader>fo", "<Cmd>Oil --float<CR>", { desc = "Oil: Open parent directory" })

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go declaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go reference" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cs", function()
    vim.lsp.buf.format({ async = false })
    vim.cmd("write")
end, { desc = "Code format and save" })
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
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Git
-- vim.keymap.set("n", "<leader>cp", "<Cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Git hunk preview inline" })
vim.keymap.set("n", "<leader>cp", "<Cmd>Gitsigns preview_hunk<CR>", { desc = "Git hunk preview" })
vim.keymap.set("n", "<leader>ct", "<Cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Git toggle line blame" })
vim.keymap.set("n", "<leader>cd", "<Cmd>Gitsigns diffthis<CR>", { desc = "Git diff this (:Gvdiff branch)" })
vim.keymap.set("n", "<leader>cb", "<Cmd>Gitsigns blame_line full=true<CR>", { desc = "Git blame line full" })
vim.keymap.set("n", "<leader>cB", "<Cmd>Gitsigns blame<CR>", { desc = "Git blame" })
vim.keymap.set("n", "<leader>cg", "<Cmd>Neogit<CR>", { desc = "Git status with neogit" })
vim.keymap.set("n", "<leader>cl", "<Cmd>0Gclog<CR>", { desc = "Git log for current file" })
vim.keymap.set("n", "<leader>ch", "<Cmd>DiffviewFileHistory %<CR>", { desc = "Git log for current file" })
vim.keymap.set("n", "<leader>cH", "<Cmd>DiffviewFileHistory<CR>", { desc = "Git log for current branch" })

-- Terminal
vim.keymap.set("n", "<leader>tv", "<Cmd>ToggleTerm direction=vertical<CR>", { desc = "Open terminal vertically" })
local Terminal = require("toggleterm.terminal").Terminal
local ipython = Terminal:new({
    cmd = "ipython3",
    direction = "vertical",
    id = 99,
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
    vim.keymap.set(
        "n",
        "<leader>ts",
        string.format("<Cmd>ToggleTermSendCurrentLine %d<CR>", ipython.id),
        { desc = "Send current line to ipython terminal" }
    )
    -- vim.keymap.set("v", "<leader>ts", "<Cmd>ToggleTermSendVisualLines<CR>", { desc = "Send selected line to terminal" })
    vim.keymap.set("v", "<leader>ts", function()
        vim.api.nvim_feedkeys('"+y', "v", true)
        require("toggleterm").exec("%paste", ipython.id)
    end, { desc = "Send @paste to ipython terminal" })
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- DAP
local dap = require("dap")
local dapui = require("dapui")
local widgets = require("dap.ui.widgets")
vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>B", dap.set_breakpoint, { desc = "Debug: Set Breakpoint" })
vim.keymap.set("n", "<Leader>dl", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Debug: Set Logpoint" })
vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "Debug: Run Last" })
vim.keymap.set({ "n", "v" }, "<Leader>dp", widgets.preview, { desc = "Debug UI: Preview Variables" })
vim.keymap.set("n", "<Leader>dc", dap.run_to_cursor, { desc = "Debug: Run to current cursor" })
vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "Debug: Terminate" })
vim.keymap.set("n", "<Leader>dF", dap.focus_frame, { desc = "Debug: Focus frame" })
vim.keymap.set("n", "<Leader>dF", function()
    widgets.centered_float(widgets.frames)
end, { desc = "Debug UI: Show Frames from dap" })
local dapui_floating_opts = { width = 90, height = 30, enter = true, position = "center" }
vim.keymap.set("n", "<Leader>df", function()
    dapui.float_element("stacks", dapui_floating_opts)
end, { desc = "Debug UI: Show Frames from dapui" })
vim.keymap.set("n", "<Leader>ds", function()
    dapui.float_element("scopes", dapui_floating_opts)
end, { desc = "Debug UI: Show Scopes" })
vim.keymap.set("n", "<Leader>dd", function()
    dapui.float_element("console", dapui_floating_opts)
end, { desc = "Debug UI: Display console" })
vim.keymap.set("n", "<Leader>dw", function()
    dapui.float_element("watches", dapui_floating_opts)
end, { desc = "Debug UI: Watches" })
vim.keymap.set("n", "<Leader>da", function()
    dapui.elements.watches.add()
    dapui.float_element("watches", dapui_floating_opts)
end, { desc = "Debug UI: Add to watches" })
vim.keymap.set("n", "<Leader>dr", function()
    dapui.float_element("repl", dapui_floating_opts)
end, { desc = "Debug: Toggle REPL" })
vim.keymap.set("n", "<Leader>du", function()
    dapui.toggle({ reset = true })
end, { desc = "DAP UI: Toggle" })
vim.keymap.set("n", "<Leader>dh", dapui.eval, { desc = "DAP UI: Hover Variables" })
vim.keymap.set("v", "<Leader>dh", dapui.eval, { desc = "DAP UI: evaluate expression" })
-- Auto close
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end
