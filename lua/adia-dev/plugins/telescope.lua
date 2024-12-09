return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"folke/trouble.nvim",
		{ "Decodetalkers/csharpls-extended-lsp.nvim" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("csharpls_definition")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		-- Core functionality
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>fu", "<cmd>Telescope resume<cr>", { desc = "Resume the last search" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

		-- Additional keybindings
		keymap.set("n", "<leader>cw", "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "List workspace symbols" })
		keymap.set("n", "<leader>cd", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "List document symbols" })
		keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
		keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
		keymap.set("n", "<leader>wl", vim.lsp.buf.list_workspace_folders, { desc = "List workspace folders" })

		-- Extended functionality
		keymap.set("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "List available commands" })
		keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "List keymaps" })
		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "List open buffers" })
		keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help tags" })
		keymap.set("n", "<leader>fq", "<cmd>Telescope quickfix<cr>", { desc = "List quickfix items" })
		keymap.set("n", "<leader>fv", "<cmd>Telescope vim_options<cr>", { desc = "List Vim options" })

		-- Git-related keybindings
		keymap.set("n", "<leader>fgc", "<cmd>Telescope git_commits<cr>", { desc = "List git commits" })
		keymap.set("n", "<leader>fgb", "<cmd>Telescope git_branches<cr>", { desc = "List git branches" })
		keymap.set("n", "<leader>fgs", "<cmd>Telescope git_status<cr>", { desc = "List git status changes" })
	end,
}
