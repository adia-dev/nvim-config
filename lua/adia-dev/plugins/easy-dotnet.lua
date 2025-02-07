return {
	{
		"GustavEikaas/easy-dotnet.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"stevearc/overseer.nvim",
		},
		keys = {
			-- Project operations
			{ "<leader>dr", "<cmd>Dotnet run<cr>", desc = "Run project" },
			{ "<leader>db", "<cmd>Dotnet build<cr>", desc = "Build project" },
			{ "<leader>dc", "<cmd>Dotnet clean<cr>", desc = "Clean project" },
			{ "<leader>dt", "<cmd>Dotnet restore<cr>", desc = "Restore dependencies" },

			-- Testing
			{ "<leader>dtr", "<cmd>Dotnet testrunner<cr>", desc = "Open test runner" },
			{ "<leader>dtt", "<cmd>Dotnet test<cr>", desc = "Run tests" },
			{ "<leader>dtf", "<cmd>Dotnet testrunner refresh<cr>", desc = "Refresh test runner" },
			{ "<leader>dtb", "<cmd>Dotnet testrunner refresh build<cr>", desc = "Rebuild and refresh tests" },

			-- Package management
			{ "<leader>dpa", "<cmd>Dotnet add package<cr>", desc = "Add package" },
			{ "<leader>dpr", "<cmd>Dotnet remove package<cr>", desc = "Remove package" },
			{ "<leader>dpo", "<cmd>Dotnet outdated<cr>", desc = "Check outdated packages" },

			-- Solution management
			{ "<leader>dss", "<cmd>Dotnet solution select<cr>", desc = "Select solution" },
			{ "<leader>dsa", "<cmd>Dotnet solution add<cr>", desc = "Add project to solution" },
			{ "<leader>dsr", "<cmd>Dotnet solution remove<cr>", desc = "Remove project from solution" },

			-- Project view
			{ "<leader>dpv", "<cmd>Dotnet project view<cr>", desc = "Open project view" },

			-- Entity Framework
			{ "<leader>deu", "<cmd>Dotnet ef database update<cr>", desc = "Update database" },
			{ "<leader>ded", "<cmd>Dotnet ef database drop<cr>", desc = "Drop database" },
			{
				"<leader>dema",
				function()
					vim.ui.input({ prompt = "Migration name: " }, function(name)
						if name then
							vim.cmd("Dotnet ef migrations add " .. name)
						end
					end)
				end,
				desc = "Add migration",
			},
			{ "<leader>demr", "<cmd>Dotnet ef migrations remove<cr>", desc = "Remove migration" },
			{ "<leader>deml", "<cmd>Dotnet ef migrations list<cr>", desc = "List migrations" },
		},
		config = function()
			local logPath = vim.fn.stdpath("data") .. "/easy-dotnet/build.log"
			local dotnet = require("easy-dotnet")

			-- Function to get user secrets path
			local function get_secret_path(secret_guid)
				local path = ""
				local home_dir = vim.fn.expand("~")
				if vim.fn.has("win32") == 1 then
					path = home_dir .. "\\AppData\\Roaming\\Microsoft\\UserSecrets\\" .. secret_guid .. "\\secrets.json"
				else
					path = home_dir .. "/.microsoft/usersecrets/" .. secret_guid .. "/secrets.json"
				end
				return path
			end

			dotnet.setup({
				test_runner = {
					viewmode = "buf",
					enable_buffer_test_execution = true,
					noBuild = true,
					noRestore = true,
					icons = {
						passed = "󰗡", -- Success checkmark
						skipped = "󰙎", -- Skip icon
						failed = "󰅚", -- Error icon
						success = "󰄴", -- Different success symbol
						reload = "󰑐", -- Reload symbol
						test = "󰙨", -- Test tube icon
						sln = "󰘐", -- VS solution icon
						project = "󰏗", -- Project folder
						dir = "󰉋", -- Directory icon
						package = "󰏗", -- Package icon
						running = "󰑮", -- Running state
						loading = "󰑮", -- Loading animation
						debug = "󰃤", -- Debug icon
						error = "󰅚", -- Error icon
						warn = "󰀦", -- Warning icon
						info = "󰋼", -- Info icon
						hint = "", -- Hint icon
						unit_test = "󰙨", -- Unit test icon
						database = "󰆼", -- Database icon
						migration = "󰁨", -- Migration icon
						reference = "󰌹", -- Reference icon
						class = "󰠱", -- Class icon
						method = "󰆧", -- Method icon
						property = "󰜢", -- Property icon
						field = "󰜢", -- Field icon
						interface = "󰠱", -- Interface icon
						enum = "󰯻", -- Enum icon
						namespace = "󰅩", -- Namespace icon
					},
					mappings = {
						run_test_from_buffer = { lhs = "<leader>rt", desc = "Run test from buffer" },
						filter_failed_tests = { lhs = "<leader>ff", desc = "Filter failed tests" },
						debug_test = { lhs = "<leader>dtd", desc = "Debug test" },
						go_to_file = { lhs = "gf", desc = "Go to file" },
						run_all = { lhs = "<leader>ra", desc = "Run all tests" },
						run = { lhs = "<leader>r", desc = "Run test" },
						peek_stacktrace = { lhs = "<leader>ps", desc = "Peek stacktrace" },
						expand = { lhs = "o", desc = "Expand" },
						expand_node = { lhs = "E", desc = "Expand node" },
						expand_all = { lhs = "-", desc = "Expand all" },
						collapse_all = { lhs = "W", desc = "Collapse all" },
						close = { lhs = "q", desc = "Close testrunner" },
						refresh_testrunner = { lhs = "<C-r>", desc = "Refresh testrunner" },
					},
				},
				terminal = function(path, action)
					local commands = {
						run = function()
							return "dotnet run --project " .. path
						end,
						test = function()
							return "dotnet test " .. path
						end,
						restore = function()
							return "dotnet restore --configfile " .. os.getenv("NUGET_CONFIG") .. " " .. path
						end,
						build = function()
							return "dotnet build  " .. path .. " /flp:v=q /flp:logfile=" .. logPath
						end,
					}

					local function filter_warnings(line)
						if not line:find("warning") then
							return line:match("^(.+)%((%d+),(%d+)%)%: (.+)$")
						end
					end

					local overseer_components = {
						{ "on_complete_dispose", timeout = 30 },
						"default",
						{ "unique", replace = true },
						{
							"on_output_parse",
							parser = {
								diagnostics = {
									{ "extract", filter_warnings, "filename", "lnum", "col", "text" },
								},
							},
						},
						{
							"on_result_diagnostics_quickfix",
							open = true,
							close = true,
						},
					}

					if action == "run" or action == "test" then
						table.insert(overseer_components, { "restart_on_save", paths = { vim.fn.getcwd() } })
					end

					local command = commands[action]()
					local task = require("overseer").new_task({
						strategy = {
							"toggleterm",
							use_shell = false,
							direction = "horizontal",
							open_on_start = false,
						},
						name = action,
						cmd = command,
						cwd = vim.fn.getcwd(),
						components = overseer_components,
					})
					task:start()
				end,
				secrets = {
					path = get_secret_path,
				},
				csproj_mappings = true,
				fsproj_mappings = true,
				auto_bootstrap_namespace = {
					type = "block_scoped",
					enabled = true,
				},
				picker = "telescope",
			})

			-- Register the completion source for nvim-cmp
			local has_cmp, cmp = pcall(require, "cmp")
			if has_cmp then
				cmp.register_source("easy-dotnet", dotnet.package_completion_source)
			end
		end,
	},
}
