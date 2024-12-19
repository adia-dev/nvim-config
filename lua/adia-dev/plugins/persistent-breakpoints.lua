return {
	"Weissle/persistent-breakpoints.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("persistent-breakpoints").setup({
			load_breakpoints_event = { "BufReadPost" },
		})
	end,
}
