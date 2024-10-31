vim.g.mapleader = " "

local keymap = vim.keymap

-- Open Rex command
keymap.set("n", "<leader>e", vim.cmd.Rex, { desc = "Open Rex command", silent = true })

-- Move by visual lines instead of actual lines
keymap.set("n", "j", "gj", { desc = "Move down by visual line", silent = true })
keymap.set("n", "k", "gk", { desc = "Move up by visual line", silent = true })

-- Exit insert mode
keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode", silent = true })

-- Delete character without yanking
keymap.set("n", "x", '"_x', { desc = "Delete character without yanking", silent = true })
keymap.set("x", "<leader>p", '"_dP', { desc = "Paste over selection without yanking", silent = true })

-- Yank to system clipboard
keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard", silent = true })
keymap.set("v", "<leader>y", '"+y', { desc = "Yank selection to system clipboard", silent = true })
keymap.set("v", "Y", '"+y', { desc = "Yank selection to system clipboard", silent = true })
keymap.set("n", "<leader>Y", 'mzgg"+yG`z', { desc = "Yank entire buffer to system clipboard", silent = true })

-- Split the tab
keymap.set("n", "<leader>z", "<CMD>tab split<CR>", { desc = "Split window into new tab", silent = true })

-- Replace whole buffer with default register
keymap.set("n", "<leader>rp", "ggvGP", { desc = "Replace entire buffer with default register", silent = true })

-- Replace whole buffer with system clipboard
keymap.set("n", "<leader>rP", ":%d|put +<CR>", { desc = "Replace entire buffer with system clipboard", silent = true })

-- Center search results
keymap.set("n", "n", "nzzzv", { desc = "Next search result and center", silent = true })
keymap.set("n", "N", "Nzzzv", { desc = "Previous search result and center", silent = true })

-- Move selected lines up or down
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down", silent = true })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up", silent = true })

-- Join lines without moving cursor
keymap.set("n", "J", "mzJ`z", { desc = "Join line below to current line without moving cursor", silent = true })

-- Scroll and center cursor
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page and center", silent = true })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page and center", silent = true })

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights", silent = true })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically", silent = true })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally", silent = true })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize window sizes", silent = true })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current window", silent = true })

-- Source current file
keymap.set("n", "<leader>so", ":so<CR>", { desc = "Source current file", silent = true })

-- Search and replace word under cursor
keymap.set("n", "<leader>ss", '"zyiw :%s/<C-r>z/<C-r>z/g<Left><Left>', { desc = "Search and replace word under cursor", silent = true })

-- Navigate quickfix list and center
keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz", { desc = "Next item in quickfix list and center", silent = true })
keymap.set("n", "<C-p>", "<cmd>cprev<CR>zz", { desc = "Previous item in quickfix list and center", silent = true })

-- Open tmux-sessionizer in new tmux window
keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "Open tmux-sessionizer in new tmux window", silent = true })

-- Close quickfix window
keymap.set("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix window", silent = true })

-- Resize windows
keymap.set("n", "<leader><Left>", ":vertical resize +2<CR>", { desc = "Increase window width", silent = true })
keymap.set("n", "<leader><Right>", ":vertical resize -2<CR>", { desc = "Decrease window width", silent = true })
keymap.set("n", "<leader><Up>", ":resize +2<CR>", { desc = "Increase window height", silent = true })
keymap.set("n", "<leader><Down>", ":resize -2<CR>", { desc = "Decrease window height", silent = true })

-- Toggle Alacritty opacity
local opacity_state = true
local function toggle_opacity()
    if opacity_state then
        vim.cmd("silent !alacritty msg config window.opacity=0.50")
        opacity_state = false
    else
        vim.cmd("silent !alacritty msg config window.opacity=1.0")
        opacity_state = true
    end
end

-- Toggle Alacritty blur
local blur_state = true
local function toggle_blur()
    if blur_state then
        vim.cmd("silent !alacritty msg config window.blur=true")
        blur_state = false
    else
        vim.cmd("silent !alacritty msg config window.blur=false")
        blur_state = true
    end
end

keymap.set("n", "<leader>ot", toggle_opacity, { desc = "Toggle Alacritty opacity between 50% and 100%", silent = true })
keymap.set("n", "<leader>bt", toggle_blur, { desc = "Toggle Alacritty blur (true/false)", silent = true })

-- Open in Neovide
keymap.set("n", "<leader>nv", ":!neovide .<CR>", { desc = "Open current directory in Neovide", silent = true })

-- URL encode function
local function url_encode(str)
    if str then
        str = string.gsub(str, "\n", "\r\n")
        str = string.gsub(str, "([^%w _%%%-%.~])",
            function(c) return string.format("%%%02X", string.byte(c)) end)
        str = string.gsub(str, " ", "+")
    end
    return str
end

-- Search in Arc browser
function SearchInArc()
    -- Check if there is a visual selection
    local selected_text = ""
    if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
        -- Get the visually selected text
        vim.cmd('normal! "vy') -- Yank the visual selection to register 'v'
        selected_text = vim.fn.getreg('v')
    else
        -- If no visual selection, get the word under the cursor
        selected_text = vim.fn.expand("<cword>")
    end

    -- Encode the selected text for a safe URL search
    local search_query = url_encode(selected_text)

    -- Construct the search URL and open it in Arc Browser
    os.execute('open -a "Arc" "https://www.google.com/search?q=' .. search_query .. '"')
end

-- Key mappings to trigger the search function
keymap.set('v', '<leader>sa', ':lua SearchInArc()<CR>', { desc = "Search selected text in Arc browser", noremap = true, silent = true })
keymap.set('n', '<leader>sa', ':lua SearchInArc()<CR>', { desc = "Search word under cursor in Arc browser", noremap = true, silent = true })
