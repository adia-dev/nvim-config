require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"ts_ls",
		"html",
		"cssls",
		"tailwindcss",
		"svelte",
		"lua_ls",
		"emmet_ls",
		"clangd",
		"rust_analyzer",
		"pyright",
		"prismals",
	},

	automatic_installation = true,
})
require("mason-null-ls").setup({
	ensure_installed = {
		"prettier",
		"stylua",
		"eslint_d",
	},
})

-- require("mason-nvim-dap").setup({
-- 	ensure_installed = { "codelldb" },
-- 	handlers = {},
-- })
