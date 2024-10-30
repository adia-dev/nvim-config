require("telescope").load_extension("fzf")
require('telescope').load_extension('dap')

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })
vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>fp", builtin.grep_string, { desc = "Grep string under cursor" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

-- Git-specific commands
vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
vim.keymap.set("n", "<leader>ggs", builtin.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>gfc", builtin.git_bcommits, { desc = "Git file commits" })
vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })

vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume last search" })
vim.keymap.set("n", "<leader>fv", builtin.command_history, { desc = "Command history" })
vim.keymap.set("n", "<leader>fw", function()
    builtin.grep_string({ search = vim.fn.expand("<cword>") })
end, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>fb", require("telescope").extensions.file_browser.file_browser, { desc = "File Browser" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
vim.keymap.set("n", "<leader>fa", builtin.commands, { desc = "Find commands" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Workspace diagnostics" })
