return {
	"mbbill/undotree",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{ "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Toggles the Undo tree" },
	},
}
