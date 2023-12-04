require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fs', builtin.git_files, {})
vim.keymap.set('n', '<leader>fp', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fr', function() builtin.grep_string({ search = vim.fn.getreg('"') }) end)
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set("n", "<leader>gc", builtin.git_commits) 
vim.keymap.set("n", "<leader>ggs", builtin.git_status)
vim.keymap.set("n", "<leader>gggs", builtin.git_status)
vim.keymap.set("n", "<leader>gfc", builtin.git_bcommits)
vim.keymap.set("n", "<leader>gb", builtin.git_branches) 

