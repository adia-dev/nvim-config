require("lspsaga").setup({
	ui = {
		code_action = "🦀",
	},
	definition = {
		keys = {
			edit = "o",
		},
	},
	diagnostic = {
		max_height = 0.8,
		keys = {
			quit = { "q", "<ESC>" },
		},
	},
	outline = {
		layout = "float",
		keys = {
			toggle_or_jump = "<CR>",
			quit = "q",
			jump = "e",
		},
	},
	rename = {
		in_select = false,
		auto_save = true,
		keys = {
			quit = { "<ESC>" },
		},
		whole_project = true,
	},
	implement = {
		enable = true,
	},
})
