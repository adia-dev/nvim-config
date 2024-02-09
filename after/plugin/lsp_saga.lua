require("lspsaga").setup({
	ui = {
		code_action = "🦀",
	},
    definition = {
        keys = {
            edit = 'o'
        }
    },
	diagnostic = {
		max_height = 0.8,
		keys = {
			quit = { "q", "<ESC>" },
		},
	},
    outline = {
        auto_close = true,
        close_after_jump = true,
        keys = {
            toggle_or_jump = 'o',
            quit = 'q',
            jump = 'e',
        }
    }
})
