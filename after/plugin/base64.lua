local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Function to encode a string in base64
local function encode_base64(input)
    local handle = io.popen('printf "%s" "' .. input .. '" | base64')
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s", "") -- Remove any whitespace characters
end

-- Function to decode a string from base64
local function decode_base64(input)
    local handle = io.popen('printf "%s" "' .. input .. '" | base64 --decode')
    local result = handle:read("*a")
    handle:close()
    return result
end

-- Visual mode mappings
vim.cmd [[
  vnoremap <leader>64 y:lua _G.visual_encode()<CR>  " Encode selected text in base64"
  vnoremap <leader>d64 y:lua _G.visual_decode()<CR> " Decode selected text from base64"
]]

-- Normal mode mappings with descriptions
keymap('n', '<leader>w64', [[:lua _G.word_encode()<CR>]],
    vim.tbl_extend('force', opts, { desc = "Encode word to base64" }))
keymap('n', '<leader>wd64', [[:lua _G.word_decode()<CR>]],
    vim.tbl_extend('force', opts, { desc = "Decode word from base64" }))
keymap('n', '<leader>64', [[:lua _G.register_encode()<CR>]],
    vim.tbl_extend('force', opts, { desc = "Encode register to base64" }))
keymap('n', '<leader>d64', [[:lua _G.register_decode()<CR>]],
    vim.tbl_extend('force', opts, { desc = "Decode register from base64" }))


-- Define the functions in the global table _G

-- Function to encode selected text
function _G.visual_encode()
    local mode = vim.fn.visualmode()
    if mode == 'V' then -- Visual line mode
        vim.cmd("normal! gv")
    else
        vim.cmd("normal! `[v`]") -- Reselect visual selection
    end
    local text = vim.fn.getreg('"')
    local encoded = encode_base64(text)
    vim.fn.setreg('z', encoded)
    vim.cmd('normal! "zP')
end

-- Function to decode selected text
function _G.visual_decode()
    local mode = vim.fn.visualmode()
    if mode == 'V' then -- Visual line mode
        vim.cmd("normal! gv")
    else
        vim.cmd("normal! `[v`]") -- Reselect visual selection
    end
    local text = vim.fn.getreg('"')
    local decoded = decode_base64(text)
    vim.fn.setreg('z', decoded)
    vim.cmd('normal! "zP')
end

-- Function to encode the word under the cursor
function _G.word_encode()
    local word = vim.fn.expand('<cword>')
    local encoded = encode_base64(word)
    vim.fn.setreg('z', encoded)
    vim.cmd('normal! ciw')
    vim.cmd('normal! "zP')
end

-- Function to decode the word under the cursor
function _G.word_decode()
    local word = vim.fn.expand('<cword>')
    local decoded = decode_base64(word)
    vim.fn.setreg('z', decoded)
    vim.cmd('normal! ciw')
    vim.cmd('normal! "zP')
end

-- Function to encode register content
function _G.register_encode()
    local reg_content = vim.fn.getreg('"')
    local encoded = encode_base64(reg_content)
    vim.fn.setreg('z', encoded)
    vim.cmd('normal! "zP')
end

-- Function to decode register content
function _G.register_decode()
    local reg_content = vim.fn.getreg('"')
    local decoded = decode_base64(reg_content)
    vim.fn.setreg('z', decoded)
    vim.cmd('normal! "zP')
end
