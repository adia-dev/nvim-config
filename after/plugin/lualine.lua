local blink = true
local timer = vim.loop.new_timer()

-- Blinking every seconds to reming my dumbass that I am recording a macro
timer:start(0, 1000, vim.schedule_wrap(function()
    blink = not blink
    vim.cmd('redrawstatus')
end))

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 200, -- Refresh the status line every 200ms
            tabline = 200,
            winbar = 200,
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            "branch",
            "filename",
            "filetype",
            {
                -- Recording status with blinking effect
                function()
                    local recording = vim.fn.reg_recording()
                    if recording ~= '' then
                        return ' ' .. recording
                    end
                    return ''
                end,
                cond = function()
                    return vim.fn.reg_recording() ~= ''
                end,
                color = function()
                    if blink then
                        return { fg = '#ff0000', gui = 'bold' } -- Blinking red
                    else
                        return { fg = '#000000', gui = 'bold' } -- Invisible to simulate blink
                    end
                end,
            },
            -- {
            --     -- Last yanked preview component
            --     function()
            --         local yanked_content = vim.fn.getreg('"'):gsub('%s+', ' ') -- Trim whitespace
            --         yanked_content = vim.trim(yanked_content)                  -- Remove leading/trailing whitespace

            --         if yanked_content == '' then
            --             return '📋: (empty)'
            --         end

            --         if #yanked_content > 30 then
            --             return '📋: ' .. yanked_content:sub(1, 27) .. '...'
            --         else
            --             return '📋: ' .. yanked_content
            --         end
            --     end,
            --     cond = function()
            --         return vim.fn.getreg('"') ~= ''
            --     end,
            --     color = { fg = '#cccccc', gui = 'bold' }, -- Grey color for visibility
            -- },
        },
        lualine_c = {
            {
                function()
                    local blame = vim.fn.system('git blame -L ' .. vim.fn.line('.') .. ',+1 -- ' .. vim.fn.expand('%'))
                    local author = blame:match('%((.-)%)')
                    if author then
                        return ' ' .. author
                    end
                    return ''
                end,
                color = { fg = '#aaaaaa', gui = 'italic' },
            }
        },
        lualine_x = {
            {
                function()
                    local msg = 'No Active Lsp'
                    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then
                        return msg
                    end
                    local clientNames = ""
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            if string.len(clientNames) == 0 then
                                clientNames = client.name
                            else
                                clientNames = clientNames .. ", " .. client.name
                            end
                        end
                    end

                    if string.len(clientNames) > 0 then
                        return clientNames
                    else
                        return msg
                    end
                end,
                icon = ' LSP:',
                color = { fg = '#ffffff', gui = 'bold' },
            }
        },
        lualine_y = {
            {
                function()
                    local mem = (collectgarbage("count") / 1024)
                    return string.format('Memory: %.2f MB', mem)
                end,
                color = { fg = '#ffaa00', gui = 'bold' },
            },
        },
        lualine_z = {},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
})

-- Autocommand to periodically refresh the status line to ensure consistent blinking
vim.cmd([[
  augroup LualineBlink
    autocmd!
    autocmd CursorHold,CursorHoldI * redrawstatus
  augroup END
]])
