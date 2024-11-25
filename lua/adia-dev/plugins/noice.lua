return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- add any options here
	},
	keys = {
		{
			"<leader>me",
			"<cmd>Noice telescope<cr>",
			desc = "Open the Noice telescope window to list messages/notifications",
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
	},
}
