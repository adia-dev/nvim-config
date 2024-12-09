return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
		{ "Decodetalkers/csharpls-extended-lsp.nvim" },
		-- { "Hoffs/omnisharp-extended-lsp.nvim" },
	},
	config = function()
		local lspconfig = require("lspconfig")

		local mason_lspconfig = require("mason-lspconfig")

		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap

		local pid = vim.fn.getpid()

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", vim.lsp.buf.definition, opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		local capabilities = cmp_nvim_lsp.default_capabilities()

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["emmet_ls"] = function()
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			["gopls"] = function()
				lspconfig["gopls"].setup({
					capabilities = capabilities,
				})
			end,
			["zls"] = function()
				lspconfig["zls"].setup({
					capabilities = capabilities,
				})
			end,
			["lua_ls"] = function()
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
			["clangd"] = function()
				lspconfig["clangd"].setup({
					capabilities = capabilities,
					cmd = {
						"clangd",
						"--background-index", -- Enable background indexing
						"--clang-tidy", -- Enable clang-tidy checks
						"--completion-style=detailed", -- Show detailed completions
						"--header-insertion=iwyu", -- Use IWYU-style headers
						"--header-insertion-decorators",
					},
					init_options = {
						clangdFileStatus = true, -- Provides file status updates
					},
				})
			end,
			["csharp_ls"] = function()
				lspconfig["csharp_ls"].setup({
					capabilities = capabilities,
					handlers = {
						["textDocument/definition"] = require("csharpls_extended").handler,
						["textDocument/typeDefinition"] = require("csharpls_extended").handler,
					},
				})
			end,
			-- ["omnisharp"] = function()
			-- 	lspconfig["omnisharp"].setup({
			-- 		cmd = {
			-- 			"/Users/ab.dia/devtools/dotnet/dotnet",
			-- 			"/usr/local/bin/omnisharp-roslyn/Omnisharp.dll",
			-- 			"--languageserver",
			-- 			"--hostPID",
			-- 			tostring(pid),
			-- 		},
			-- 		-- handlers = {
			-- 		-- 	["textDocument/definition"] = require("omnisharp_extended").definition_handler,
			-- 		-- 	["textDocument/typeDefinition"] = require("omnisharp_extended").type_definition_handler,
			-- 		-- 	["textDocument/references"] = require("omnisharp_extended").references_handler,
			-- 		-- 	["textDocument/implementation"] = require("omnisharp_extended").implementation_handler,
			-- 		-- },
			-- 		capabilities = capabilities,
			-- 		settings = {
			-- 			FormattingOptions = {
			-- 				EnableEditorConfigSupport = true,
			-- 				OrganizeImports = true,
			-- 			},
			-- 			MsBuild = {
			-- 				LoadProjectsOnDemand = true,
			-- 			},
			-- 			RoslynExtensionsOptions = {
			-- 				EnableAnalyzersSupport = true,
			-- 				EnableImportCompletion = true,
			-- 				AnalyzeOpenDocumentsOnly = nil,
			-- 			},
			-- 			Sdk = {
			-- 				IncludePrereleases = true,
			-- 			},
			-- 		},
			-- 	})
			-- end,
		})
	end,
}
