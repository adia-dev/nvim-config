require("telescope").load_extension("fzf")
require('telescope').load_extension('dap')
local actions = require("telescope.actions")
-- local trouble = require("trouble.providers.telescope")

-- require("telescope").setup({
--     defaults = {
--         mappings = {
--             i = { ["<c-t>"] = trouble.open_with_trouble },
--             n = { ["<c-t>"] = trouble.open_with_trouble },
--         },
--     },
-- })

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, {})
vim.keymap.set("n", "<leader>fS", builtin.lsp_workspace_symbols, {})
vim.keymap.set("n", "<leader>fp", builtin.grep_string, {})
vim.keymap.set("n", "<leader>fr", function()
    builtin.grep_string({ search = vim.fn.getreg('"') })
end)
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

vim.keymap.set("n", "<leader>gc", builtin.git_commits)
vim.keymap.set("n", "<leader>ggs", builtin.git_status)
vim.keymap.set("n", "<leader>gfc", builtin.git_bcommits)
vim.keymap.set("n", "<leader>gb", builtin.git_branches)
