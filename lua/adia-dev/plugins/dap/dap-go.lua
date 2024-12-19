return {
	"leoluz/nvim-dap-go",
	cmd = { "Dap" },
	config = function()
		require("dap-go").setup()
	end,
}
