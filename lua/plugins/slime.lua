return {
    "jpalardy/vim-slime",
    dependencies = { "akinsho/toggleterm.nvim", "Klafyvel/vim-slime-cells" },
    init = function()
        vim.g.slime_target = "neovim"
        vim.g.slime_no_mappings = 1
        vim.g.slime_python_ipython = 1
        vim.g.slime_cell_delimiter = "^\\s*#\\s*%%"
    end,
    config = function()
        local refresh = {}
        vim.api.nvim_create_user_command("SlimeConfig", function()
            local source = vim.api.nvim_get_current_buf()
            local terminals = {}
            for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
                if vim.bo[buffer].buftype == "terminal" then
                    local job = vim.bo[buffer].channel
                    if job > 0 and vim.fn.jobwait({ job }, 0)[1] == -1 then
                        table.insert(terminals, { buffer = buffer, jobid = job })
                    end
                end
            end
            if #terminals == 0 then
                vim.notify("Open a REPL first", vim.log.levels.WARN)
                return
            end
            vim.ui.select(terminals, {
                prompt = "Select REPL terminal",
                format_item = function(terminal)
                    local title = vim.b[terminal.buffer].term_title or vim.api.nvim_buf_get_name(terminal.buffer)
                    return title .. " (job " .. terminal.jobid .. ")"
                end,
            }, function(terminal)
                if not terminal or not vim.api.nvim_buf_is_valid(source) then
                    return
                end
                if vim.fn.jobwait({ terminal.jobid }, 0)[1] ~= -1 then
                    vim.notify("Selected terminal has exited", vim.log.levels.WARN)
                    return
                end
                vim.b[source].slime_config = {
                    jobid = terminal.jobid,
                    pid = vim.fn.jobpid(terminal.jobid),
                }
                if refresh[source] then refresh[source]() end
            end)
        end, { desc = "Select REPL terminal", force = true })
        vim.api.nvim_create_user_command("SlimeInsertCell", function()
            local row = vim.api.nvim_win_get_cursor(0)[1]
            local indent = vim.api.nvim_get_current_line():match("^%s*")
            local delimiter = vim.bo.filetype == "haskell" and "-- %%" or "# %%"
            vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, { indent .. delimiter })
        end, { desc = "Insert cell delimiter above current line" })
        local terminals = {}
        for filetype, command in pairs({
            python = "ipython3",
            julia = "julia --project=.",
            haskell = "ghci",
        }) do
            terminals[filetype] = require("toggleterm.terminal").Terminal:new({
                cmd = command,
                direction = "vertical",
                hidden = true,
            })
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("SlimeRepl", { clear = true }),
            pattern = { "python", "julia", "haskell" },
            callback = function(event)
                local filetype = vim.bo[event.buf].filetype
                local terminal = terminals[filetype]
                local function connected()
                    local config = vim.b[event.buf].slime_config
                    local job = config and tonumber(config.jobid)
                    return job ~= nil and job > 0 and vim.fn.jobwait({ job }, 0)[1] == -1
                end
                vim.b[event.buf].slime_bracketed_paste = filetype == "julia" and 1 or 0
                vim.b[event.buf].slime_cell_delimiter = filetype == "haskell" and "^\\s*--\\s*%%" or "^\\s*#\\s*%%"
                vim.keymap.set("n", "<leader>ro", function()
                    terminal:toggle()
                    if filetype == "python" then
                        vim.b[event.buf].slime_bracketed_paste = 0
                        vim.b[event.buf].slime_python_ipython = 1
                    end
                    vim.b[event.buf].slime_config = {
                        jobid = terminal.job_id,
                        pid = vim.fn.jobpid(terminal.job_id),
                    }
                    refresh[event.buf]()
                end, { buffer = event.buf, desc = "Open REPL" })
                local mappings = {
                    { "n", "<S-CR>", "<Plug>SlimeCellsSendAndGoToNext", "Send cell and advance" },
                    { "i", "<S-CR>", "<Esc><Plug>SlimeCellsSendAndGoToNext", "Send cell and advance" },
                    { { "n", "i" }, "<C-CR>", "<Cmd>call slime#send_cell()<CR>", "Send cell and stay" },
                    { { "x", "o" }, "ic", ":<C-u>call slime_cells#select_current_cell(0)<CR>", "Select cell contents" },
                    { { "x", "o" }, "ac", ":<C-u>call slime_cells#select_current_cell(1)<CR>", "Select cell with delimiter" },
                    { "n", "<leader>rn", "<Plug>SlimeCellsSendAndGoToNext", "Send cell and advance" },
                    { "n", "<leader>rj", "<Plug>SlimeCellsNext", "Next cell" },
                    { "n", "<leader>rk", "<Plug>SlimeCellsPrev", "Previous cell" },
                    { "n", "<leader>ri", "<Cmd>SlimeInsertCell<CR>", "Insert cell delimiter" },
                    { "n", "<leader>rl", "<Plug>SlimeLineSend", "Send line to REPL" },
                    { "x", "<leader>rs", "<Plug>SlimeRegionSend", "Send selection to REPL" },
                    { "n", "<leader>rs", "<Plug>SlimeSendCell", "Send cell to REPL" },
                    { "n", "<leader>rc", "<Plug>SlimeConfig", "Select REPL terminal" },
                }
                if filetype == "python" then
                    table.insert(mappings, { "n", "<leader>rf", function()
                        vim.cmd("write")
                        local file = vim.fn.expand("%:p")
                        terminal:open()
                        terminal:send("%run " .. vim.fn.fnameescape(file))
                    end, "Run current file in IPython" })
                end
                refresh[event.buf] = function()
                    local active = connected()
                    for _, mapping in ipairs(mappings) do
                        vim.keymap.set(mapping[1], mapping[2], active and mapping[3] or "<Nop>", {
                            buffer = event.buf,
                            remap = true,
                            silent = true,
                            desc = active and mapping[4] or "which_key_ignore",
                        })
                    end
                end
                refresh[event.buf]()
                if filetype == "julia" or filetype == "python" then
                    vim.keymap.set("n", "<leader>rJ", function()
                        require("jupyter_viewer").open(event.buf, refresh[event.buf])
                    end, { buffer = event.buf, desc = "Jupyter terminal + browser (auto setup)" })
                    vim.keymap.set("n", "<leader>ij", function()
                        require("jupyter_viewer").open(event.buf, refresh[event.buf])
                    end, { buffer = event.buf, desc = "Jupyter terminal + browser viewer" })
                end
            end,
        })
        vim.api.nvim_create_autocmd({ "BufEnter", "TermClose" }, {
            group = "SlimeRepl",
            callback = function()
                vim.schedule(function()
                    for buffer, update in pairs(refresh) do
                        if vim.api.nvim_buf_is_valid(buffer) then
                            update()
                        else
                            refresh[buffer] = nil
                        end
                    end
                end)
            end,
        })
    end,
}
