return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs", -- Display tabs instead of buffers
			numbers = "ordinal", -- Show tab numbers
			diagnostics = "nvim_lsp", -- Integrate LSP diagnostics
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local icon = level:match("error") and " " or " "
				return " " .. icon .. count
			end,
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "center",
					separator = true,
				},
			},
			show_buffer_close_icons = false, -- Hide buffer close icons
			show_close_icon = false, -- Hide main close icon
			separator_style = "thin", -- Use slant separators
			always_show_bufferline = true, -- Always display the bufferline
		},
	},
}
