require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = {}, winbar = {} },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
    },
    sections = {
        lualine_a = {
            "mode",
            {
                function()
                    if vim.fn.mode() == 'n' and vim.fn.searchcount({ 'all' }).total > 0 then
                        return '🔍 Search'
                    end
                    return ''
                end,
                color = { fg = '#ff4500', gui = 'bold' },
            },
        },
        lualine_b = {
            "branch",
            "filename",
            {
                "filetype",
                icon_only = true,
                color = { fg = '#ffffff', gui = 'bold' },
            },
            {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                sections = { 'error', 'warn' },
                symbols = { error = ' ', warn = ' ' },
                colored = true,
                update_in_insert = false,
                always_visible = false,
            },
            {
                'diff',
                colored = true,
                symbols = { added = ' ', modified = ' ', removed = ' ' },
            },
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
            },
            {
                function()
                    local mem = (collectgarbage("count") / 1024)
                    return string.format('Memory: %.2f MB', mem)
                end,
                color = { fg = '#ffaa00', gui = 'bold' },
            },
            "encoding",
            "filesize",
        },
        lualine_y = {
            {
                function()
                    return os.date('%H:%M:%S')
                end,
                color = { fg = '#ffaa00', gui = 'bold' },
            }
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
    extensions = {},
})
