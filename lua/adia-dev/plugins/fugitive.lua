return {
	"tpope/vim-fugitive",
	cmd = { "Git" },
	keys = {
		{ "<leader>gg", "<cmd>Git<cr>", desc = "Open git" },
		{ "<leader>ge", "<cmd>Git commit --amend --no-edit<cr>", desc = "Amend the commit no edit" },
	},
}
