vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "<leader>ga", ":Git add %:p<CR><CR>");
vim.keymap.set("n", "<leader>ge", ":Git commit --amend --no-edit <CR><CR>");
vim.keymap.set("n", "<leader>gps", ":Git push <CR><CR>");
vim.keymap.set("n", "<leader>gpl", ":Git pull --rebase<CR><CR>");
