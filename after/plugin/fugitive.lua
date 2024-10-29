-- Git Commands
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open Git status" })
vim.keymap.set("n", "<leader>ga", "<CMD>Git add %:p<CR>", { desc = "Git add current file" })
vim.keymap.set("n", "<leader>gc", "<CMD>Git commit<CR>", { desc = "Git commit" })
vim.keymap.set("n", "<leader>gA", "<CMD>Git commit --amend --no-edit<CR>", { desc = "Amend last commit" })
vim.keymap.set("n", "<leader>gp", "<CMD>Git push<CR>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gP", "<CMD>Git pull --rebase<CR>", { desc = "Git pull with rebase" })
vim.keymap.set("n", "<leader>gl", "<CMD>Git log<CR>", { desc = "View Git log" })

-- Git Diffing
vim.keymap.set("n", "<leader>gd", "<CMD>Gvdiffsplit!<CR>", { desc = "Git diff split" })
vim.keymap.set("n", "<leader>gq", "<CMD>q<CR><CMD>diffoff!<CR>", { desc = "Close diff view" })
-- vim.keymap.set("n", "<leader>gh", "<CMD>diffget //2<CR>", { desc = "Get left side in diff" })
-- vim.keymap.set("n", "<leader>gl", "<CMD>diffget //3<CR>", { desc = "Get right side in diff" })
