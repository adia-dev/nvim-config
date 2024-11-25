return {
	"rcarriga/nvim-dap-ui",
	cmd = { "Dap" },
	dependencies = { "nvim-neotest/nvim-nio" },
  -- stylua: ignore
  keys = {
    { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
  },
	opts = {},
	config = function(_, opts)
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup(opts)
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open({})
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close({})
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close({})
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dap-repl",
			callback = function()
				require("dap.ext.autocompl").attach()
			end,
		})

		-- Customize UI icons
		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error" })
		vim.fn.sign_define("DapStopped", { text = "", texthl = "Warning" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "Hint" })
	end,
}
