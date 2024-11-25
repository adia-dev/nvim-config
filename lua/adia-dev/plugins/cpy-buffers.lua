return {
	"adia-dev/cpy_buffers.nvim",
	event = "VeryLazy",
	config = function()
		require("cpy_buffers").setup({})
	end,
}
