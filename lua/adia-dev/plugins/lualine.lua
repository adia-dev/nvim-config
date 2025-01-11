return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- for lazy pending updates count

		local colors = {
			blue = "#65D1FF",
			green = "#3EFFDC",
			violet = "#FF61EF",
			yellow = "#FFDA7B",
			red = "#FF4A4A",
			fg = "#c3ccdc",
			bg = "#112638",
			inactive_bg = "#2c3043",
			semilightgray = "#bbbbbb", -- define semilightgray if you use it in inactive
		}

		local my_lualine_theme = {
			normal = {
				a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			insert = {
				a = { bg = colors.green, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			visual = {
				a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			command = {
				a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			replace = {
				a = { bg = colors.red, fg = colors.bg, gui = "bold" },
				b = { bg = colors.bg, fg = colors.fg },
				c = { bg = colors.bg, fg = colors.fg },
			},
			inactive = {
				a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
				b = { bg = colors.inactive_bg, fg = colors.semilightgray },
				c = { bg = colors.inactive_bg, fg = colors.semilightgray },
			},
		}

		-- Custom component to display "current/total" search matches
		local function search_count()
			-- Only show if a search pattern exists
			if vim.fn.getreg("/") == "" then
				return ""
			end

			-- Use Vim's built-in searchcount() function
			local sc = vim.fn.searchcount({ recompute = true, maxcount = 9999 })
			if sc.total > 0 then
				return string.format("%d/%d", sc.current, sc.total)
			end
			return ""
		end

		-- Display number of characters in the current buffer
		local function file_chars_count()
			local wc = vim.fn.wordcount()
			-- `wc.chars` includes all characters (not just alphanumeric). Adjust if needed.
			return wc.chars .. " chars"
		end

		-- Optionally, you can also show line:column info using lualine's built-in 'location' or custom:
		-- local function line_col()
		--   local line = vim.fn.line('.')
		--   local col = vim.fn.col('.')
		--   return string.format("%d:%d", line, col)
		-- end

		lualine.setup({
			options = {
				theme = my_lualine_theme,
				-- You can also set component_separators, section_separators, etc.
				-- component_separators = { left = "", right = "" },
				-- section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" }, -- example: show Vim mode
				lualine_b = { "branch" },
				lualine_c = { "filename" },
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{
						function()
							return "Recording"
						end,
						icon = "",
						cond = function()
							return vim.fn.reg_recording() ~= ""
						end,
						color = { fg = "red" },
					},
					-- show search count: "n/N"
					{
						search_count,
						icon = "", -- optional: search icon
					},
					-- show total characters in the file
					{
						file_chars_count,
						icon = "", -- optional: tweak or remove as you like
					},
					-- built-in filetype component
					{ "filetype" },
				},
				-- If you want line:col info, can use built-in 'location' or define your own
				lualine_y = { "location" },
				lualine_z = { "progress" },
			},
		})
	end,
}
