-- Set the leader key to space
vim.g.mapleader = " "

-- Define keymap for easier reference
local keymap = vim.keymap

-- General Keymaps
keymap.set("n", "j", "gj", { desc = "Move down by visual line" })
keymap.set("n", "k", "gk", { desc = "Move up by visual line" })
keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Clipboard
keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap.set("v", "<leader>y", '"+y', { desc = "Yank selection to system clipboard" })
keymap.set("n", "<leader>Y", 'mzgg"+yG`z', { desc = "Yank entire buffer to system clipboard" })

-- Text Manipulation
keymap.set("n", "x", '"_x', { desc = "Delete character without yanking" })
keymap.set("x", "p", '"_dP', { desc = "Paste over selection without yanking" })
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
keymap.set("v", "<", "<gv", { desc = "Unindent selection" })
keymap.set("v", ">", ">gv", { desc = "Indent selection" })

-- Search Enhancements
keymap.set("n", "n", "nzzzv", { desc = "Next search result and center" })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights", silent = true })

-- Buffer Operations
keymap.set(
	"n",
	"<leader>rp",
	":%d|put 0<CR>ggdd",
	{ desc = "Replace entire buffer with default register", silent = true }
)
keymap.set(
	"n",
	"<leader>rP",
	":%d|put +<CR>ggdd",
	{ desc = "Replace entire buffer with system clipboard", silent = true }
)
keymap.set("n", "<leader><Tab>", "<C-^>", { desc = "Switch to last buffer" })

-- Window Management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current window", silent = true })

-- Resize Windows
keymap.set("n", "<leader><Left>", ":vertical resize +2<CR>", { desc = "Increase window width", silent = true })
keymap.set("n", "<leader><Right>", ":vertical resize -2<CR>", { desc = "Decrease window width", silent = true })
keymap.set("n", "<leader><Up>", ":resize +2<CR>", { desc = "Increase window height", silent = true })
keymap.set("n", "<leader><Down>", ":resize -2<CR>", { desc = "Decrease window height", silent = true })

-- Tabs Management
keymap.set("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab", silent = true })
keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close current tab", silent = true })
keymap.set("n", "<leader>tx", ":tabonly<CR>", { desc = "Close all other tabs", silent = true })
keymap.set("n", "<leader>tm", ":tabmove +1<CR>", { desc = "Move tab right", silent = true })
keymap.set("n", "<leader>tM", ":tabmove -1<CR>", { desc = "Move tab left", silent = true })
keymap.set("n", "<leader>tt", ":tabs<CR>", { desc = "List all tabs" })
keymap.set("n", "<leader>tp", ":tabprevious<CR>", { desc = "Go to previous tab", silent = true })
keymap.set("n", "<leader>tn", ":tabnext<CR>", { desc = "Go to next tab", silent = true })

-- Miscellaneous
keymap.set("n", "<leader>so", ":so<CR>", { desc = "Source current file", silent = true })
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page and center" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page and center" })

-- TMUX Sessionizer: Open in TMUX Popup with Custom Size
keymap.set(
	"n",
	"<C-f>",
	"<cmd>silent !tmux popup -w 100 -h 30 'tmux-sessionizer'<CR>",
	{ desc = "Open tmux-sessionizer" }
)

-- Custom Functions
local opacity_state = false
local blur_state = false

local function toggle_opacity()
	if opacity_state then
		vim.cmd("silent !alacritty msg config window.opacity=0.85")
	else
		vim.cmd("silent !alacritty msg config window.opacity=0.50")
	end
	opacity_state = not opacity_state
end

local function toggle_blur()
	if blur_state then
		vim.cmd("silent !alacritty msg config window.blur=false")
	else
		vim.cmd("silent !alacritty msg config window.blur=true")
	end
	blur_state = not blur_state
end

-- keymap.set("n", "<leader>aot", toggle_opacity, { desc = "Toggle Alacritty opacity" })
-- keymap.set("n", "<leader>abt", toggle_blur, { desc = "Toggle Alacritty blur" })
