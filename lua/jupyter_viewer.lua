local M = {}
local terminals = {}

function M.open(source, refresh)
    local language = vim.bo[source].filetype
    if vim.fn.executable("uv") == 0 or (language == "julia" and vim.fn.executable("julia") == 0) then
        vim.notify("Install uv first (and julia for Julia buffers). Jupyter setup instructions appear in the terminal.", vim.log.levels.ERROR)
        return
    end
    local file = vim.api.nvim_buf_get_name(source)
    local start = file ~= "" and file or vim.fn.getcwd()
    local markers = language == "julia" and { "Project.toml", "JuliaProject.toml" } or { "pyproject.toml", ".venv", ".git" }
    local project = vim.fs.root(start, markers)
    if not project and language == "python" then
        project = file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
    end
    if not project then
        vim.notify("No Julia project found above this file. Open a file inside your Julia project.", vim.log.levels.ERROR)
        return
    end
    local python = nil
    if language == "python" then
        local ok, venv_selector = pcall(require, "venv-selector")
        python = ok and venv_selector.python() or nil
        if not python then
            vim.notify("Select a Python environment first with :VenvSelect", vim.log.levels.WARN)
            return
        end
    end
    local key = language .. ":" .. project .. ":" .. (python or "")
    local terminal = terminals[key]
    if not terminal then
        local script = vim.fn.stdpath("config") .. "/scripts/jupyter_viewer.py"
        local kernel_env = vim.fn.stdpath("data") .. "/" .. language .. "-kernel"
        local command = "uv run --script " .. vim.fn.shellescape(script)
            .. " --language " .. language
            .. " --project " .. vim.fn.shellescape(project)
            .. " --kernel-env " .. vim.fn.shellescape(kernel_env)
        if python then
            command = command .. " --python " .. vim.fn.shellescape(python)
        end
        terminal = require("toggleterm.terminal").Terminal:new({
            cmd = command,
            dir = project,
            direction = "vertical",
            hidden = true,
            on_exit = function()
                terminals[key] = nil
            end,
        })
        terminals[key] = terminal
    end
    terminal:toggle()
    vim.b[source].slime_config = { jobid = terminal.job_id, pid = vim.fn.jobpid(terminal.job_id) }
    vim.b[source].slime_bracketed_paste = 1
    if language == "python" then
        vim.b[source].slime_python_ipython = 0
    end
    refresh()
end

return M
