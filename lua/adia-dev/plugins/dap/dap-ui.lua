return {
	"rcarriga/nvim-dap-ui",
	cmd = { "Dap" },
	dependencies = { "nvim-neotest/nvim-nio" },
  -- stylua: ignore
  keys = {
    { "<leader>du", function() require("dapui").toggle({ reset = true }) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
  },
	opts = {
		-- Remove "repl" by omitting it from the layout elements
		layouts = {
			{
				elements = { "scopes", "breakpoints", "stacks", "watches" },
				size = 0.33,
				position = "left",
			},
			{
				elements = { "repl" }, -- Only repl here, no "console"
				size = 0.27,
				position = "bottom",
			},
		},
	},
	config = function(_, opts)
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup(opts)

		-- Automatically open UI when debug session starts
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({})
		end

		-- (Commented out) Automatically close UI when debug session ends
		dap.listeners.before.event_terminated["dapui_config"] = function()
			-- dapui.close({})
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			-- dapui.close({})
		end

		-- Enable autocompletion in the DAP REPL if you ever open/enable it
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dap-repl",
			callback = function()
				require("dap.ext.autocompl").attach()
			end,
		})

		-- Auto-scroll the console on every UI refresh
		vim.api.nvim_create_autocmd("User", {
			pattern = "DAPUIRefresh",
			callback = function()
				if vim.bo.filetype == "dapui_console" then
					local last_line = vim.fn.line("$")
					vim.api.nvim_win_set_cursor(0, { last_line, 0 })
				end
			end,
		})

		-- Customize DAP UI icons
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error" })
		vim.fn.sign_define("DapStopped", { text = "", texthl = "Warning" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "Hint" })
	end,
}
