-- plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin
require("lazy").setup("plugins")

-- Base settings
vim.opt.history = 3000
vim.opt.encoding = "utf-8"
vim.opt.cursorline = true
vim.opt.number = true

-- Tab, indent
vim.opt.smarttab = true
vim.opt.expandtab = true        
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0  -- Use tabstop value


-- Case sensitive \C to disable it
vim.opt.ignorecase = true
vim.opt.smartcase = true


