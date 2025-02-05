return {
	"stevearc/overseer.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local overseer = require("overseer")

		overseer.setup({
			strategy = "toggleterm",
		})

		overseer.register_template({
			name = "Run Make",
			builder = function(params)
				return {
					cmd = "make",
					args = {},
					components = { "default", "on_complete_notify", "on_complete_dispose" },
				}
			end,
			condition = {
				callback = function()
					return vim.fn.filereadable("Makefile") == 1
				end,
			},
		})

		overseer.register_template({
			name = "make_run",
			builder = function(params)
				return {
					cmd = { "make", "run" },
					args = {},
					components = { "default", "on_complete_notify", "on_complete_dispose" },
				}
			end,
			condition = {
				callback = function()
					return vim.fn.filereadable("Makefile") == 1
				end,
			},
		})

		overseer.register_template({
			name = "make_clean",
			builder = function(params)
				return {
					cmd = { "make", "clean" },
					args = {},
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
		keymap.set("n", "<leader>ovt", ":OverseerToggle<CR>", { desc = "Toggle task manager", noremap = true })
		keymap.set("n", "<leader>ovr", ":OverseerRun<CR>", { desc = "Run a task", noremap = true })
		keymap.set("n", "<leader>ovs", ":OverseerQuickAction stop<CR>", { desc = "Stop current task", noremap = true })

		keymap.set("n", "<leader>mr", ":OverseerRun make_run<CR>", { desc = "Run make run task", noremap = true })
		keymap.set("n", "<leader>mc", ":OverseerRun make_clean<CR>", { desc = "Run make clean task", noremap = true })
	end,
}
