local opt = vim.opt
local api = vim.api

-- General settings
opt.relativenumber = true
opt.number = true

-- Tabs and indentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.inccommand = "nosplit"

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
opt.swapfile = true
opt.directory= os.getenv("HOME") .. "/.vim/swp"

opt.backup = true
opt.backupdir = os.getenv("HOME") .. "/.vim/bak"

opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Completion settings
opt.completeopt = "longest,menu,menuone,noselect"

-- Search highlighting
opt.hlsearch = true
opt.incsearch = true

-- Scrolling and sign column
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

-- Update time
opt.updatetime = 250

-- Netrw settings
vim.g.netrw_preview = 1
vim.g.netrw_winsize = 30
vim.g.netrw_keepdir = 0

-- Diagnostic settings
vim.diagnostic.config({
    virtual_text = false,
})
