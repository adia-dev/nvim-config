return {
	"epwalsh/obsidian.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"nvim-treesitter/nvim-treesitter",
		"kyazdani42/nvim-web-devicons",
	},
	cmd = { "ObsidianToday", "ObsidianNew", "ObsidianOpen" },
	ft = { "markdown" },
	keys = {
		{ "<leader>oi", "<cmd>ObsidianOpen<CR>", desc = "Open Obsidian" },
		{ "<leader>on", "<cmd>ObsidianNew<CR>", desc = "New Note" },
		{ "<leader>ot", "<cmd>ObsidianToday<CR>", desc = "Today's Note" },
		{ "<leader>pi", "<cmd>ObsidianPasteImg<CR>", desc = "Paste Image from Clipboard" },
	},
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents",
			},
			{
				name = "work",
				path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Criteo",
				overrides = {
					notes_subdir = "notes",
				},
			},
		},
		notes_subdir = "notes",
		log_level = vim.log.levels.INFO,
		daily_notes = {
			folder = "notes/dailies",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily-notes" },
			template = nil,
		},
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			["<CR>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
		new_notes_location = "notes_subdir",
		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,
		note_path_func = function(spec)
			local path = spec.dir / tostring(spec.id)
			return path:with_suffix(".md")
		end,
		wiki_link_func = function(opts)
			return require("obsidian.util").wiki_link_id_prefix(opts)
		end,
		markdown_link_func = function(opts)
			return require("obsidian.util").markdown_link(opts)
		end,
		preferred_link_style = "wiki",
		disable_frontmatter = false,
		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			substitutions = {},
		},
		ui = {
			enable = true,
			update_debounce = 200,
			max_file_length = 5000,
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
				["!"] = { char = "", hl_group = "ObsidianImportant" },
			},
			bullets = { char = "•", hl_group = "ObsidianBullet" },
			external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
			reference_text = { hl_group = "ObsidianRefText" },
			highlight_text = { hl_group = "ObsidianHighlightText" },
			tags = { hl_group = "ObsidianTag" },
			block_ids = { hl_group = "ObsidianBlockID" },
			hl_groups = {
				ObsidianTodo = { bold = true, fg = "#f78c6c" },
				ObsidianDone = { bold = true, fg = "#89ddff" },
				ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
				ObsidianTilde = { bold = true, fg = "#ff5370" },
				ObsidianImportant = { bold = true, fg = "#d73128" },
				ObsidianBullet = { bold = true, fg = "#89ddff" },
				ObsidianRefText = { underline = true, fg = "#c792ea" },
				ObsidianExtLinkIcon = { fg = "#c792ea" },
				ObsidianTag = { italic = true, fg = "#89ddff" },
				ObsidianBlockID = { italic = true, fg = "#89ddff" },
				ObsidianHighlightText = { bg = "#75662e" },
			},
		},
		attachments = {
			img_folder = "assets/imgs",
			img_name_func = function()
				return string.format("%s-", os.time())
			end,
			img_text_func = function(client, path)
				path = client:vault_relative_path(path) or path
				return string.format("![%s](%s)", path.name, path)
			end,
			handle_paste = true,
		},
		follow_url_func = function(url)
			vim.fn.jobstart({ "open", url })
		end,
		follow_img_func = function(img)
			vim.fn.jobstart({ "qlmanage", "-p", img })
		end,
		use_advanced_uri = false,
		open_app_foreground = false,
		picker = {
			name = "telescope.nvim",
			note_mappings = {
				new = "<C-x>",
				insert_link = "<C-l>",
			},
			tag_mappings = {
				tag_note = "<C-x>",
				insert_tag = "<C-l>",
			},
		},
		sort_by = "modified",
		sort_reversed = true,
		search_max_lines = 1000,
		open_notes_in = "current",
		callbacks = {
			post_setup = function(client) end,
			enter_note = function(client, note) end,
			leave_note = function(client, note) end,
			pre_write_note = function(client, note) end,
			post_set_workspace = function(client, workspace) end,
		},
	},
}
