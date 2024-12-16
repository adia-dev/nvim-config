return {
	"mfussenegger/nvim-dap",
	cmd = { "Dap" },
	recommended = true,
	desc = "Debugging support. Requires language-specific adapters to be configured. (see lang extras)",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
	},

	keys = {
		{ "<leader>d", "", desc = "+debug", mode = { "n", "v" } },
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Breakpoint Condition",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Run/Continue",
		},
		{
			"<leader>dC",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "Run to Cursor",
		},
		{
			"<leader>dg",
			function()
				require("dap").goto_()
			end,
			desc = "Go to Line (No Execute)",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<leader>dj",
			function()
				require("dap").down()
			end,
			desc = "Down",
		},
		{
			"<leader>dk",
			function()
				require("dap").up()
			end,
			desc = "Up",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "Run Last",
		},
		{
			"<leader>do",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
		{
			"<leader>dO",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<leader>dp",
			function()
				require("dap").pause()
			end,
			desc = "Pause",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.toggle()
			end,
			desc = "Toggle REPL",
		},
		{
			"<leader>ds",
			function()
				require("dap").session()
			end,
			desc = "Session",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "Terminate",
		},
		{
			"<leader>dw",
			function()
				require("dap.ui.widgets").hover()
			end,
			desc = "Widgets",
		},

		-- Function key mappings
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Run/Continue",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<F12>",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
		{
			"<F9>",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<S-F9>",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Conditional Breakpoint",
		},
		{
			"<F8>",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "Run to Cursor",
		},
		{
			"<S-F5>",
			function()
				require("dap").terminate()
			end,
			desc = "Terminate Debugging",
		},
	},

	config = function()
		local dap = require("dap")

		LazyVim = {
			has = function(plugin)
				return require("lazy.core.config").plugins[plugin] ~= nil
			end,
			opts = function(plugin)
				return require("lazy.core.config").plugins[plugin].opts or {}
			end,
			config = {
				icons = {
					dap = {
						Stopped = { "", "DiagnosticWarn", "DapStoppedLine" },
						Breakpoint = { "", "DiagnosticInfo" },
						LogPoint = { "", "DiagnosticInfo" },
						BreakpointCondition = { "", "DiagnosticInfo" },
					},
				},
			},
		}

		-- Load mason-nvim-dap
		if LazyVim.has("mason-nvim-dap.nvim") then
			require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
		end

		vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

		for name, sign in pairs(LazyVim.config.icons.dap) do
			sign = type(sign) == "table" and sign or { sign }
			vim.fn.sign_define(
				"Dap" .. name,
				{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
			)
		end

		-- Setup dap config by VSCode launch.json file
		local vscode = require("dap.ext.vscode")
		local json = require("plenary.json")
		vscode.json_decode = function(str)
			return vim.json.decode(json.json_strip_comments(str))
		end

		-- Filtering of the bin selection in Telescope
		local function filter_bin(entry)
			local relative = entry:match(".*/(bin/.*)")
			if relative then
				return { value = entry, display = relative, ordinal = relative }
			end
			return nil
		end

		-- Helper for program selection in Telescope
		local function select_program(bin_filter, filter_function)
			return coroutine.create(function(coro)
				local pickers = require("telescope.pickers")
				local finders = require("telescope.finders")
				local conf = require("telescope.config").values
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				pickers
					.new({}, {
						prompt_title = "Select Executable",
						finder = finders.new_oneshot_job(
							{ "find", vim.fn.getcwd(), "-type", "f", "-name", bin_filter },
							{
								cwd = vim.fn.getcwd(),
								entry_maker = function(entry)
									if filter_function then
										local filtered = filter_function(entry)
										if not filtered then
											return nil -- Skip if filtering returns nil
										end
										return filtered
									end
									-- Default entry maker if no filter is applied
									return { value = entry, display = entry, ordinal = entry }
								end,
							}
						),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_bufnr, _)
							actions.select_default:replace(function()
								local selection = action_state.get_selected_entry()
								actions.close(prompt_bufnr)
								coroutine.resume(coro, selection.value)
							end)
							return true
						end,
					})
					:find()
			end)
		end

		-- Binaries
		local codelldb_path = "~/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/adapter/codelldb"

		-- Adapters
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = os.getenv("HOME") .. codelldb_path,
				args = {
					"--port",
					"${port}",
					"--liblldb",
					"/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB",
				},
			},
		}

		dap.adapters.lldb = { type = "executable", command = "/opt/homebrew/bin/lldb-dap", name = "lldb" }
		dap.adapters.coreclr = {
			type = "executable",
			command = "/usr/local/bin/netcoredbg/netcoredbg",
			args = { "--interpreter=vscode" },
		}

		dap.configurations.cpp = {
			{
				name = "Launch C++ File",
				type = "lldb",
				request = "launch",
				program = function()
					return select_program("*")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				console = "integratedTerminal",
			},
		}

		dap.configurations.zig = {
			{
				name = "Launch Zig File",
				type = "lldb",
				request = "launch",
				program = function()
					return select_program("zig-out/*")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				console = "integratedTerminal",
			},
		}

		dap.configurations.cs = {
			{
				name = "Launch .NET Core",
				type = "coreclr",
				request = "launch",
				program = function()
					return select_program("*.dll", filter_bin)
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				console = "integratedTerminal",
			},
		}

		-- Ensure C works the same as C++ setup
		dap.configurations.c = dap.configurations.cpp
	end,
}
