vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>e", vim.cmd.Rex)

keymap.set("n", "j", "gj")
keymap.set("n", "k", "gk")

keymap.set("i", "jk", "<Esc>")

keymap.set("n", "x", '"_x')
keymap.set("x", "<leader>p", "\"_dP")

keymap.set("n", "<leader>y", "\"+y")
keymap.set("v", "<leader>y", "\"+y")
keymap.set("n", "<leader>Y", "mzgg\"+yG`z")

keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "J", "mzJ`z")

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set("n", "<leader>nh", ":nohl<CR>")

keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sx", ":close<CR>")


keymap.set("n", "<leader>so", ":so<CR>")

keymap.set("n", "<leader>s", "\"zyiw :%s/<C-r>z/<C-r>z/g<Left><Left>")


keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz")
keymap.set("n", "<C-p>", "<cmd>cprev<CR>zz")
keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")


keymap.set("n", "<leader>cc", ":cclose<CR>")
