local opt = vim.opt


-- tabs and indentation
opt.relativenumber = true
opt.number = true

-- tabs and indentation
opt.tabstop = 4
opt.ignorecase = true
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.autoindent = true
opt.smartindent = true

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.background = "dark"

opt.backspace = "indent,eol,start"

opt.splitright = true
opt.splitbelow = true

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.completeopt = "menu,menuone,noselect"

opt.hlsearch = true
opt.incsearch = true

opt.termguicolors = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime  = 50

vim.g.netrw_preview = 1
vim.g.netrw_winsize = 30
vim.g.netrw_keepdir = 0


