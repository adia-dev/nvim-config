return {
	"stevearc/overseer.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local overseer = require("overseer")

		-- Initialize Overseer
		overseer.setup({
			strategy = "terminal", -- Show tasks in an integrated terminal
		})

		-- Define the `make` task
		overseer.register_template({
			name = "Run Make",
			builder = function(params)
				return {
					cmd = "make",
					args = {}, -- Add any specific arguments for make
					components = { "default", "on_complete_notify", "on_complete_dispose" },
				}
			end,
			condition = {
				callback = function()
					return vim.fn.filereadable("Makefile") == 1
				end,
			},
		})

		-- Keymaps for task management
		local keymap = vim.keymap
		keymap.set("n", "<leader>ot", ":OverseerToggle<CR>", { desc = "Toggle task manager", noremap = true })
		keymap.set("n", "<leader>or", ":OverseerRun<CR>", { desc = "Run a task", noremap = true })
		keymap.set("n", "<leader>os", ":OverseerQuickAction stop<CR>", { desc = "Stop current task", noremap = true })
		keymap.set("n", "<leader>ol", ":OverseerOpen<CR>", { desc = "Open task list", noremap = true })
	end,
}
