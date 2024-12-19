return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		require("tokyonight").setup({
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		})
		vim.cmd("colorscheme tokyonight")
	end,
}

-- return {
-- 	"rebelot/kanagawa.nvim",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd("colorscheme kanagawa")
-- 		require("kanagawa").setup({
-- 			transparent = true,
-- 			-- styles = {
-- 			-- 	sidebars = "transparent",
-- 			-- 	floats = "transparent",
-- 			-- },
-- 		})
-- 	end,
-- }
