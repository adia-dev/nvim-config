vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "<leader>ga", ":Git add %:p<CR><CR>");
vim.keymap.set("n", "<leader>ge", ":Git commit --amend --no-edit <CR><CR>");
vim.keymap.set("n", "<leader>gps", ":Git push <CR><CR>");
vim.keymap.set("n", "<leader>gpl", ":Git pull --rebase<CR><CR>");
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit! <CR>");
vim.keymap.set("n", "<leader>gq", "<C-w>o<CR>diffoff!");
vim.keymap.set("n", "<leader>gl", ":GcLog<CR>");

vim.keymap.set("n", "<leader>dl", ":diffget //2<CR>");
vim.keymap.set("n", "<leader>dr", ":diffget //3<CR>");
