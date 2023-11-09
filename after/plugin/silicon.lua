function TakeScreenShot(visual, highlighted)
    vim.ui.input({ prompt = 'Enter file name: ', default = vim.fn.expand("%:t") },
        function(input)
            local screenshot_dir = '~/Documents/Screenshots/Code/'
            vim.fn.mkdir(screenshot_dir, 'p')

            local file_name = input ~= '' and input or os.date('%Y%m%d%H%M%S')

            file_name = screenshot_dir .. file_name .. '.png'

            local silicon_cmd = "Silicon"

            if visual == true then
                silicon_cmd = "'<,'>" .. silicon_cmd

                if highlighted == true then
                    silicon_cmd = silicon_cmd .. "!"
                end
            end

            silicon_cmd = silicon_cmd .. " " .. file_name .. " --to-clipboard=true"

            vim.cmd(silicon_cmd)
        end)
end

-- Mapping the function to a key combination in visual mode
vim.api.nvim_set_keymap('n', '<leader>ts', ':lua TakeScreenShot()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<leader>ts', ':lua TakeScreenShot(true)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<leader>ths', ':lua TakeScreenShot(true, true)<CR>', { noremap = true, silent = true })
