vim.cmd([[packadd packer.nvim]])
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost packer.lua source <afile> | PackerSync
augroup end
]])

return require("packer").startup(function(use)
    -- Load and manage Packer itself
    use("wbthomason/packer.nvim")

    -- Theme
    use("navarasu/onedark.nvim")
    use({ "rose-pine/neovim", as = "rose-pine" })

    -- Navigation
    use("christoomey/vim-tmux-navigator")
    use("szw/vim-maximizer")

    -- Telescope for fuzzy finding
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        requires = { { "nvim-lua/plenary.nvim" } },
    })
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    })

    -- UI
    use({ "stevearc/dressing.nvim" })

    -- LSP and related
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

    use({ "elixir-tools/elixir-tools.nvim", tag = "stable", requires = { "nvim-lua/plenary.nvim" } })
    use("https://github.com/scalameta/nvim-metals")

    -- Treesitter
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
    use("nvim-treesitter/playground")
    use("nvim-treesitter/nvim-treesitter-textobjects")

    -- Undo tree
    use("mbbill/undotree")

    -- File explorer
    use("nvim-tree/nvim-tree.lua")
    use("nvim-tree/nvim-web-devicons")

    -- GOATPOPE
    use("tpope/vim-fugitive")
    use("tpope/vim-commentary")
    use("tpope/vim-dadbod")
    use { "kristijanhusak/vim-dadbod-ui", requires = { 'kristijanhusak/vim-dadbod-completion' } }
    use("tpope/vim-abolish")


    -- Surround
    use({
        "kylechui/nvim-surround",
        tag = "*",
        config = function()
            require("nvim-surround").setup({})
        end,
    })

    -- Status line
    use("nvim-lualine/lualine.nvim")
    -- use("andweeb/presence.nvim")

    -- Autopairs
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    })

    -- Markdown preview
    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    })

    -- Completion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")

    -- Snippets
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    use("rafamadriz/friendly-snippets")

    -- Image previews
    use { 'mistricky/codesnap.nvim', run = 'make' }

    -- Theme
    use("folke/tokyonight.nvim")

    -- LSP
    use("jose-elias-alvarez/null-ls.nvim")
    use("jayp0521/mason-null-ls.nvim")
    -- use("Civitasv/cmake-tools.nvim")
    use({ "jay-babu/mason-nvim-dap.nvim" })
    use("mfussenegger/nvim-dap")
    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } })
    use("theHamsta/nvim-dap-virtual-text")
    use("nvim-telescope/telescope-dap.nvim")
    -- use("tikhomirov/vim-glsl")
    use({
        requires = { "nvim-treesitter/nvim-treesitter" },
        "Badhi/nvim-treesitter-cpp-tools",
    })
    use("Hoffs/omnisharp-extended-lsp.nvim")

    -- Terminal
    use({ "akinsho/toggleterm.nvim", tag = "*" })

    -- Custom plugins
    use("adia-dev/cpy_buffers.nvim")
    use({ "lewis6991/gitsigns.nvim" })
    use({ "folke/noice.nvim", requires = { "MunifTanjim/nui.nvim" } })
    use({ "zakissimo/smoji.nvim" })

    -- Miscellaneous
    use({ "folke/todo-comments.nvim", requires = { "nvim-lua/plenary.nvim" } })
    use { "catppuccin/nvim", as = "catppuccin" }
    use("folke/zen-mode.nvim")
    use({ "folke/trouble.nvim" })
    use({ "folke/ts-comments.nvim" })

    -- use({
    --     "wojciech-kulik/xcodebuild.nvim",
    --     requires = {
    --         "nvim-telescope/telescope.nvim",
    --         "MunifTanjim/nui.nvim",
    --         "nvim-tree/nvim-tree.lua", -- if you want the integration with file tree
    --     },
    -- })

    use("norcalli/nvim-colorizer.lua")
    use("mfussenegger/nvim-jdtls")

    use({ "epwalsh/obsidian.nvim", tag = "*", requires = { "nvim-lua/plenary.nvim" } })

    use({ "windwp/nvim-ts-autotag" })

    use({ "terrastruct/d2-vim" })

    -- Packer
    use({
        "crnvl96/lazydocker.nvim",
        config = function()
            require("lazydocker").setup()
        end,
        requires = {
            "MunifTanjim/nui.nvim",
        },
    })

    use('reisub0/hot-reload.vim')

    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {}
        end
    }
end)
