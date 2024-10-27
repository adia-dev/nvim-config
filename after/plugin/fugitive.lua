vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "<leader>ga", "<CMD>Git add %:p<CR><CR>");
vim.keymap.set("n", "<leader>ge", "<CMD>Git commit --amend --no-edit <CR><CR>");
vim.keymap.set("n", "<leader>gps", "<CMD>Git push <CR><CR>");
vim.keymap.set("n", "<leader>gpl", "<CMD>Git pull --rebase<CR><CR>");
vim.keymap.set("n", "<leader>gd", "<CMD>Gvdiffsplit! <CR>");
vim.keymap.set("n", "<leader>gq", "<C-w>o<CR>diffoff!");
vim.keymap.set("n", "<leader>gl", "<CMD>GcLog<CR>");

vim.keymap.set("n", "<leader>dl", "<CMD>diffget //2<CR>");
vim.keymap.set("n", "<leader>dr", "<CMD>diffget //3<CR>");
