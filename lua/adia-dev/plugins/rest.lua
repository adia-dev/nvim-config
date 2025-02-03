vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json" },
	callback = function()
		vim.api.nvim_set_option_value("formatprg", "jq", { scope = "local" })
	end,
})

return {
	"rest-nvim/rest.nvim",
	cmd = { "Rest" },
	ft = { "http" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			table.insert(opts.ensure_installed, "http")
		end,
	},
	config = function()
		vim.keymap.set("n", "<leader>rr", "<CMD>Rest run<CR>")
	end,
}
