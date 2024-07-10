local opt = vim.opt
local cmd = vim.cmd
local api = vim.api
local nvim_create_autocmd = api.nvim_create_autocmd
local nvim_set_hl = api.nvim_set_hl

-- General settings
opt.relativenumber = true
opt.number = true

-- Tabs and indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.inccommand = "nosplit"

-- opt.lazyredraw = true

opt.conceallevel = 1

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true

-- Background and colors
opt.background = "dark"
opt.termguicolors = true

-- Backspace behavior
opt.backspace = "indent,eol,start"

-- Splitting behavior
opt.splitright = true
opt.splitbelow = true

-- File handling
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- Completion settings
opt.completeopt = "menu,menuone,noselect"

-- Search highlighting
opt.hlsearch = true
opt.incsearch = true

-- Scrolling and sign column
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

-- Update time
opt.updatetime = 50

-- Netrw settings
vim.g.netrw_preview = 1
vim.g.netrw_winsize = 30
vim.g.netrw_keepdir = 0

-- Diagnostic settings
-- vim.diagnostic.config({
--     virtual_text = false,
-- })
