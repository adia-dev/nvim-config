return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			init = function() end,
		},
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({ -- enable syntax highlighting
			highlight = {
				enable = true,
			},
			-- enable indentation
			indent = { enable = true },
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			autotag = {
				enable = true,
			},
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"go",
				"c",
				"cpp",
				"zig",
				"c_sharp",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<S-TAB>",
					node_incremental = "<S-TAB>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						["a="] = { query = "@assignment.outer", desc = "Select outer part of an assignment" },
						["i="] = { query = "@assignment.inner", desc = "Select inner part of an assignment" },
						["l="] = { query = "@assignment.lhs", desc = "Select left-hand side of an assignment" },
						["r="] = { query = "@assignment.rhs", desc = "Select right-hand side of an assignment" },
						["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
						["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
						["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
						["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
						["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
						["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
						["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
						["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
						["am"] = {
							query = "@function.outer",
							desc = "Select outer part of a method/function definition",
						},
						["im"] = {
							query = "@function.inner",
							desc = "Select inner part of a method/function definition",
						},
						["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
					},
					include_surrounding_whitespace = true,
				},

				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},

				lsp_interop = {
					enable = true,
					border = "none",
					floating_preview_opts = {},
					peek_definition_code = {
						["<leader>df"] = "@function.outer",
						["<leader>dF"] = "@class.outer",
					},
				},

				-- Add the move module
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
						["]a"] = "@parameter.outer",
						["]l"] = "@loop.outer",
						["]i"] = "@conditional.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
						["]A"] = "@parameter.outer",
						["]L"] = "@loop.outer",
						["]I"] = "@conditional.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
						["[a"] = "@parameter.outer",
						["[l"] = "@loop.outer",
						["[i"] = "@conditional.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
						["[A"] = "@parameter.outer",
						["[L"] = "@loop.outer",
						["[I"] = "@conditional.outer",
					},
				},
			},
		})

		local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

		-- Repeat movement with ; and ,
		-- ensure ; goes forward and , goes backward regardless of the last direction
		vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
		vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

		-- vim way: ; goes to the direction you were moving.
		-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
		-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

		-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
		vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
	end,
}
