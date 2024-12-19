return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {},
	event = "VimEnter",
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	keys = {
		{ "<leader>e", "<CMD>Oil --float<CR>", desc = "Oil that thang" },
	},
}
