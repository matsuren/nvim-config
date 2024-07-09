-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc="Find files"})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc="Live grep"})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc="Find buffers"})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {desc="Recently open files"})
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {desc="Find jumplist"})
vim.keymap.set('n', '<leader>fc', builtin.git_status, {desc="Find changes"})
vim.keymap.set('n', '<leader>fm', builtin.marks, {desc="Find marks"})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc="Find help tags"})

--  File explore 
vim.keymap.set('n', '<leader>fe', "<Cmd>Neotree toggle<CR>", {desc="File explore"})
vim.keymap.set("n", "<leader>fo", "<Cmd>Oil --float<CR>", { desc = "Open parent directory" })

