vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader>e", vim.cmd.Rex)

keymap.set("n", "j", "gj")
keymap.set("n", "k", "gk")

keymap.set("i", "jk", "<Esc>")

keymap.set("n", "x", '"_x')
keymap.set("x", "<leader>p", '"_dP')

keymap.set("n", "<leader>y", '"+y')
keymap.set("v", "<leader>y", '"+y')
keymap.set("v", "Y", '"+y')
keymap.set("n", "<leader>Y", 'mzgg"+yG`z')

-- split the tab
keymap.set("n", "<leader>z", "<CMD>tab split<CR>", { silent = true })

-- replace whole buffer
keymap.set("n", "<leader>rp", "ggvGP")

-- replace whole buffer with device clipboard
keymap.set("n", "<leader>rP", ":%d|put +<CR>", { silent = true })

keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

keymap.set("n", "J", "mzJ`z")

keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")

keymap.set("n", "<leader>nh", ":nohl<CR>", { silent = true })

keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sx", ":close<CR>", { silent = true })

keymap.set("n", "<leader>so", ":so<CR>", { silent = true })

keymap.set("n", "<leader>ss", '"zyiw :%s/<C-r>z/<C-r>z/g<Left><Left>', { silent = true })

keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz")
keymap.set("n", "<C-p>", "<cmd>cprev<CR>zz")

keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

keymap.set("n", "<leader>cc", ":cclose<CR>", { silent = true })

keymap.set("n", "<leader><Left>", ":vertical resize +2<CR>", { silent = true })
keymap.set("n", "<leader><Right>", ":vertical resize -2<CR>", { silent = true })
keymap.set("n", "<leader><Up>", ":resize +2<CR>", { silent = true })
keymap.set("n", "<leader><Down>", ":resize -2<CR>", { silent = true })

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

keymap.set("n", "<leader>ot", toggle_opacity, { desc = "Toggle Alacritty opacity between 50% and 100%" })
keymap.set("n", "<leader>bt", toggle_blur, { desc = "Toggle Alacritty blur (true/false)" })

-- Open in Neovide
keymap.set("n", "<leader>nv", ":!neovide .<CR>")

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

-- Define a function to search the selected text or the word under the cursor in Arc browser
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

-- Create a key mapping for visual mode and normal mode to trigger the search function
vim.api.nvim_set_keymap('v', '<leader>sa', ':lua SearchInArc()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sa', ':lua SearchInArc()<CR>', { noremap = true, silent = true })
