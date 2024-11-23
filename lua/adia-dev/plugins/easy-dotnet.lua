return {
	"GustavEikaas/easy-dotnet.nvim",
	cmd = { "Dotnet" },
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	config = function()
		require("easy-dotnet").setup()
	end,
}
