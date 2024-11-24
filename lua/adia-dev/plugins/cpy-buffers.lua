return {
	-- "adia-dev/cpy_buffers.nvim",
	dir = "/Users/adiadev/Projects/Dev/lua/cpy_buffers.nvim/",
	config = function()
		require("cpy_buffers").setup({
			log = {
				use_notify = false,
				level = vim.log.levels.DEBUG,
			},
		})
	end,
}
