-- Basic
-- Save with Ctrl + s
vim.keymap.set("n", "<C-s>", function()
    vim.cmd("write")
end, { silent = true })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", { silent = true })
vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>gv", { silent = true })

-- Search within visual selection
vim.keymap.set("v", "<Leader>/", "<Esc>/\\%V", { desc = "Search within the visual selection" })

-- Disable F1 help menu
vim.keymap.set("n", "<F1>", "<Nop>", { silent = true })
vim.keymap.set("i", "<F1>", "<Nop>", { silent = true })
vim.keymap.set("v", "<F1>", "<Nop>", { silent = true })
-- Disable quit action
vim.keymap.set("n", "<C-w>q", "<C-w>c", { noremap = true })

-- Readline/Emacs-style cursor movement in command mode
vim.keymap.set("c", "<C-a>", "<Home>", { noremap = true })
vim.keymap.set("c", "<C-e>", "<End>", { noremap = true })
-- vim.keymap.set("c", "<C-b>", "<Left>", { noremap = true })
-- vim.keymap.set("c", "<C-f>", "<Right>", { noremap = true }) -- conflict with open history
vim.keymap.set("c", "<M-b>", "<S-Left>", { noremap = true })
vim.keymap.set("c", "<M-f>", "<S-Right>", { noremap = true })
vim.keymap.set("c", "<C-p>", "<Up>", { noremap = true })
vim.keymap.set("c", "<C-n>", "<Down>", { noremap = true })
-- Readline/Emacs-style cursor movement in insert mode
vim.keymap.set("i", "<C-a>", "<C-o>^", { noremap = true })
vim.keymap.set("i", "<C-e>", "<C-o>$", { noremap = true })
vim.keymap.set("i", "<C-f>", "<Right>", { noremap = true })
vim.keymap.set("i", "<C-b>", "<Left>", { noremap = true })
vim.keymap.set("i", "<M-f>", "<C-o>w", { noremap = true })
vim.keymap.set("i", "<M-b>", "<C-o>b", { noremap = true })

-- Change Ctrl-arrow behavior
vim.keymap.set("n", "<C-Right>", "e", { noremap = true, silent = true })
vim.keymap.set("n", "<C-Left>", "b", { noremap = true, silent = true })
vim.keymap.set("i", "<C-Right>", "<C-o>w", { noremap = true, silent = true })
vim.keymap.set("i", "<C-Left>", "<C-o>b", { noremap = true, silent = true })
vim.keymap.set("v", "<C-Right>", "e", { noremap = true, silent = true })
vim.keymap.set("v", "<C-Left>", "b", { noremap = true, silent = true })

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
vim.keymap.set("n", "<leader>fF", ":Telescope frecency<CR>", { desc = "Find frequency used files" })
-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep_args<CR>", { desc = "Live grep with args" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recently open files" })
vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "Find jumplist" })
vim.keymap.set("n", "<leader>fc", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy find in current buffer" })
vim.keymap.set("n", "<leader>fC", builtin.command_history, { desc = "Find command history" })
vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Find marks" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help tags" })
vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Find quickfix" })
vim.keymap.set("n", "<leader>fQ", builtin.quickfixhistory, { desc = "Find quickfix history" })
vim.keymap.set("n", "<leader>fl", builtin.loclist, { desc = "Find loclist" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Find symbols via lsp" })
vim.keymap.set("n", "<leader>fd", function()
    builtin.diagnostics({ bufnr = 0 })
end, { desc = "Find diagnostics" })
vim.keymap.set("n", "<leader>fn", ":Telescope notify<CR>", { desc = "Telescope notify" })
vim.keymap.set("n", "<leader>fa", ":Telescope resume<CR>", { desc = "Telescope resume (Again)" })

--  File explore
vim.keymap.set("n", "<leader>fe", "<Cmd>Neotree reveal toggle<CR>", { desc = "File explore" })
vim.keymap.set("n", "<leader>fo", "<Cmd>Oil --float<CR>", { desc = "Oil: Open parent directory" })

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go declaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go reference" })
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
    require("conform").format({ async = true }, function(err)
        if not err then
            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
        end
    end)
end, { desc = "Format code" })
vim.keymap.set({ "n", "v" }, "<leader>cF", function()
    require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
    if not err then
        local mode = vim.api.nvim_get_mode().mode
        if vim.startswith(string.lower(mode), "v") then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        end
    end
end, { desc = "Format code in injection" })
local function toggle_inlay_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end
vim.keymap.set("n", "<leader>ci", toggle_inlay_hints, { desc = "Toggle inlay hint" })
local function insert_inlay_hints()
    require("inlayhint-filler").fill()
    local mode = vim.api.nvim_get_mode().mode
    if vim.startswith(string.lower(mode), "v") then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    end
end
vim.keymap.set("v", "<leader>ci", insert_inlay_hints, { desc = "Insert inlay hint into buffer" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>co", "<cmd>AerialToggle!<CR>", { desc = "Toggle outline" })
vim.keymap.set("n", "<leader>cO", function()
    vim.b.aerial_backends = { "lsp" }
    require("aerial").refetch_symbols(0)
end, { desc = "Outline using LSP" })

-- Git signs
local gitsigns = require("gitsigns")
vim.keymap.set("n", "<leader>ha", gitsigns.stage_hunk, { desc = "Add (Stage) hunk" })
vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
vim.keymap.set("v", "<leader>ha", function()
    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Add (Stage) hunk (visual)" })
vim.keymap.set("v", "<leader>hr", function()
    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Reset hunk (visual)" })
vim.keymap.set("n", "<leader>hA", gitsigns.stage_buffer, { desc = "Add (Stage) buffer" })
vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })
vim.keymap.set("n", "<leader>hb", function()
    gitsigns.blame_line({ full = true })
end, { desc = "Blame line" })
vim.keymap.set("n", "<leader>hB", gitsigns.blame, { desc = "Git blame" })
vim.keymap.set("n", "<leader>ht", gitsigns.toggle_current_line_blame, { desc = "Git toggle line blame" })
vim.keymap.set("n", "<leader>hd", gitsigns.toggle_deleted, { desc = "Toggle deleted" })
vim.keymap.set("n", "<leader>hw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

-- Git
vim.keymap.set("n", "<leader>cd", "<Cmd>Git -c pager.diff=delta diff %<CR>", { desc = "Git diff using delta" })
vim.keymap.set("n", "<leader>cD", "<Cmd>DiffviewOpen<CR>", { desc = "Git diffview (:DiffviewOpen)" })
vim.keymap.set("n", "<leader>cg", "<Cmd>Neogit<CR>", { desc = "Git status with neogit" })
vim.keymap.set("n", "<leader>cl", "<Cmd>0Gclog<CR>", { desc = "Git log for current file" })
vim.keymap.set("n", "<leader>cL", function()
    local current_config = vim.diagnostic.config()
    local severity_levels = { "N/A", "ERROR", "WARN", "INFO", "HINT" }
    local current_level = (
        current_config.virtual_text
        and current_config.virtual_text.severity
        and current_config.virtual_text.severity.min
    ) or 4 -- default: HINT (defined in coding.lua)
    local next_level = (current_level - 1) % 5
    vim.diagnostic.config({
        underline = {
            severity = { min = next_level },
        },
        virtual_text = {
            source = current_config.virtual_text.source,
            severity = { min = next_level },
        },
    })
    vim.notify("Diagnostic level for virtual text and underline: " .. severity_levels[next_level + 1])
end, { desc = "Cycle diagnostic severity levels for virtual text" })
vim.keymap.set("n", "<leader>ch", "<Cmd>DiffviewFileHistory %<CR>", { desc = "Git log for current file" })
vim.keymap.set("n", "<leader>cH", "<Cmd>DiffviewFileHistory<CR>", { desc = "Git log for current branch" })
vim.keymap.set("n", "<leader>cc", require("telescope.builtin").git_status, { desc = "Find git changes" })
vim.keymap.set("n", "<leader>cb", "<Cmd>G blame<CR>", { desc = "Git blame" })

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
    -- Keymap to run the current file in IPython
    vim.keymap.set("n", "<leader>tt", function()
        vim.cmd("write")
        local file = vim.fn.expand("%") -- Get the current file
        require("toggleterm").exec("%run " .. file, ipython.id)
    end, { desc = "Run current file in IPython" })
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- HakonHarnes/img-clip.nvim
vim.keymap.set("n", "<Leader>p", "<cmd>PasteImage<cr>", { desc = "Paste image from system clipboard" })
