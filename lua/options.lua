local options = {
    -- Base settings
    history = 3000,
    encoding = "utf-8",
    fileformats = "unix,mac,dos",
    swapfile = false,
    visualbell = true,
    errorbells = true,
    wrap = false,
    number = true,
    relativenumber = true,
    cursorline = true,
    undofile = true,
    updatetime = 300,
    -- Scroll
    scrolloff = 4,
    sidescrolloff = 8,
    -- Tab, indent
    smarttab = true,
    expandtab = true,
    autoindent = true,
    smartindent = true,
    tabstop = 4,
    shiftwidth = 0, -- Use tabstop value
    -- Case sensitive search. \C to disable it
    ignorecase = true,
    smartcase = true,
    wrapscan = true,
    -- Clipboard
    clipboard = "unnamedplus",
    -- Spell check
    spell = true,
    -- Always show signcolumn to avoid flicking while debugging
    signcolumn = "yes:1",
    -- Limit max number of completion items
    pumheight = 12,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
