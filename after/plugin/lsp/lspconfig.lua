-- For lsp file operations like
-- renaming an import and the file gets updated
-- or vice-versa...
require("lsp-file-operations").setup()
local pid = vim.fn.getpid()

-- Setup language servers.
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>ww", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>K", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>J", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local bufnr = ev.buf
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- Enable completion triggered by <c-x><c-o>
		vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gr", "<CMD>Telescope lsp_references<CR>", opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

		if client.name == "omnisharp" then
			local omnisharp_opts = { buffer = bufnr }
			vim.keymap.set("n", "gd", require("omnisharp_extended").lsp_definitions, omnisharp_opts)
		else
			vim.keymap.set("n", "gd", "<CMD>Telescope lsp_definitions<CR>", opts)
		end

		vim.keymap.set("n", "K", "<CMD>Lspsaga hover_doc<CR>", opts)
		vim.keymap.set("n", "gi", "<CMD>Telescope lsp_implementations<CR>", opts)
		vim.keymap.set("n", "gt", "<CMD>Telescope lsp_type_definitions<CR>", opts)
		vim.keymap.set("n", "<leader>gk", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
		vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>o", "<CMD>OrganizeImports<CR>", opts)
		vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workleader_folders()))
		end, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>fl", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.pyright.setup({
	capabilities = capabilities,
})

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

lspconfig.tsserver.setup({
	capabilities = capabilities,
	commands = {
		OrganizeImports = {
			organize_imports,
			description = "Organize Imports",
		},
	},
})
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				},
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
		},
	},
})
lspconfig.clangd.setup({
	capabilities = capabilities,
})
lspconfig.zls.setup({
	capabilities = capabilities,
})
lspconfig.emmet_ls.setup({
	capabilities = capabilities,
})
lspconfig.cmake.setup({
	capabilities = capabilities,
})
lspconfig.docker_compose_language_service.setup({
	capabilities = capabilities,
})
lspconfig.dockerls.setup({
	capabilities = capabilities,
})
lspconfig.taplo.setup({
	capabilities = capabilities,
})
lspconfig.kotlin_language_server.setup({
	capabilities = capabilities,
})

capabilities.textDocument.completion.completionItem.snippetSupport = true
local cssls_capabilities = vim.lsp.protocol.make_client_capabilities()

lspconfig.cssls.setup({
	capabilities = cssls_capabilities,
})
lspconfig.rust_analyzer.setup({
	-- Server-specific settings. See `:help lspconfig-setup`
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {},
	},
})

local omnisharp_bin = "/usr/local/bin/omnisharp-roslyn/Omnisharp.dll"

lspconfig.omnisharp.setup({
	cmd = { "dotnet", omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
	["textDocument/definition"] = require("omnisharp_extended").handler,
	capabilities = capabilities,
	-- Enables support for reading code style, naming convention and analyzer
	-- settings from .editorconfig.
	enable_editorconfig_support = true,

	-- If true, MSBuild project system will only load projects for files that
	-- were opened in the editor. This setting is useful for big C# codebases
	-- and allows for faster initialization of code navigation features only
	-- for projects that are relevant to code that is being edited. With this
	-- setting enabled OmniSharp may load fewer projects and may thus display
	-- incomplete reference lists for symbols.
	enable_ms_build_load_projects_on_demand = false,

	-- Enables support for roslyn analyzers, code fixes and rulesets.
	enable_roslyn_analyzers = true,

	-- Specifies whether 'using' directives should be grouped and sorted during
	-- document formatting.
	organize_imports_on_format = true,

	-- Enables support for showing unimported types and unimported extension
	-- methods in completion lists. When committed, the appropriate using
	-- directive will be added at the top of the current file. This option can
	-- have a negative impact on initial completion responsiveness,
	-- particularly for the first few completion sessions after opening a
	-- solution.
	enable_import_completion = true,

	-- Specifies whether to include preview versions of the .NET SDK when
	-- determining which version to use for project loading.
	sdk_include_prereleases = true,

	-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
	-- true
	analyze_open_documents_only = false,
})

