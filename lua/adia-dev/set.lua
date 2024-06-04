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
vim.diagnostic.config({
  virtual_text = false,
})

-- Whitespace display settings
opt.list = true

local space = "·"
opt.listchars:append({
  tab = "░ ",
  multispace = space,
  lead = space,
  trail = space,
  nbsp = space,
  extends = '»',
  precedes = '«'
})

-- Highlight trailing whitespace
cmd([[match TrailingWhitespace /\s\+$/]])
nvim_set_hl(0, "TrailingWhitespace", { fg = "#FF0000", bg = "#1E1E1E" })

-- Autocommands to handle trailing whitespace highlighting in insert mode
nvim_create_autocmd("InsertEnter", {
  callback = function()
    opt.listchars.trail = nil
    nvim_set_hl(0, "TrailingWhitespace", { link = "Whitespace" })
  end
})

nvim_create_autocmd("InsertLeave", {
  callback = function()
    opt.listchars.trail = space
    nvim_set_hl(0, "TrailingWhitespace", { fg = "#FF0000", bg = "#1E1E1E" })
  end
})
