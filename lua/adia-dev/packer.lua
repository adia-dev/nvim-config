vim.cmd([[packadd packer.nvim]])
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost packer.lua source <afile> | PackerSync
augroup end
]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use("navarasu/onedark.nvim")

	use("christoomey/vim-tmux-navigator")
	use("szw/vim-maximizer")

	use({ "nvim-telescope/telescope.nvim", tag = "0.1.4", requires = { { "nvim-lua/plenary.nvim" } } })
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})

	use({ "stevearc/dressing.nvim" })

	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	})

	use({
		"nvimdev/lspsaga.nvim",
		after = "nvim-lspconfig",
	})

	use({
		"antosha417/nvim-lsp-file-operations",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
	})

	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("nvim-treesitter/playground")
	use("nvim-lua/plenary.nvim")
	use("mbbill/undotree")

	use("nvim-tree/nvim-tree.lua")
	use("nvim-tree/nvim-web-devicons")

	-- GoaTPope
	use("tpope/vim-fugitive")
	use("tpope/vim-commentary")
	use("tpope/vim-dadbod")
	use("tpope/vim-abolish")

	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})

	use("nvim-lualine/lualine.nvim")
	use("andweeb/presence.nvim")
	-- use("JoosepAlviste/nvim-ts-context-commentstring")

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})

	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")

	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")

	use("segeljakt/vim-silicon")
	use("folke/tokyonight.nvim")

	use("jose-elias-alvarez/null-ls.nvim")
	use("jayp0521/mason-null-ls.nvim")

	use("Civitasv/cmake-tools.nvim")
	use({ "jay-babu/mason-nvim-dap.nvim" })
	use("mfussenegger/nvim-dap")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use("theHamsta/nvim-dap-virtual-text")

	use("tikhomirov/vim-glsl")
	use({
		requires = { "nvim-treesitter/nvim-treesitter" },
		"Badhi/nvim-treesitter-cpp-tools",
	})
	use("Hoffs/omnisharp-extended-lsp.nvim")

	use({ "akinsho/toggleterm.nvim", tag = "*" })

	use '~/Projects/Dev/lua/cpy_buffers.nvim'

	-- use({
	-- 	"adia-dev/cpy_buffers.nvim",
	-- 	requires = { "nvim-telescope/telescope.nvim" },
	-- })

	use({ "lewis6991/gitsigns.nvim" })

	use({ "rose-pine/neovim", as = "rose-pine" })

	use({ "folke/noice.nvim" })
	use({ "MunifTanjim/nui.nvim" })

	use({ "olekatpyle/xunit.nvim" })
	use({ "zakissimo/smoji.nvim" })

	-- use("rcarriga/nvim-notify")
	use({ "folke/todo-comments.nvim", requires = { "nvim-lua/plenary.nvim" } })
end)
