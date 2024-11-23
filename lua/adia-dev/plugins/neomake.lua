return {
	"neomake/neomake",
	config = function()
		-- Open the location list automatically if there are linting issues
		vim.g.neomake_open_list = 2

		-- Set up custom key mappings
		local keymap = vim.keymap

		-- Run Neomake on the current file
		keymap.set("n", "<leader>m", ":Neomake<CR>", { desc = "Run Neomake on current file", noremap = true })

		-- Run project-level Neomake
		keymap.set("n", "<leader>M", ":Neomake!<CR>", { desc = "Run Neomake project-wide", noremap = true })

		-- Optionally enable detailed logging
		vim.g.neomake_logfile = "/tmp/neomake.log"
	end,
}
