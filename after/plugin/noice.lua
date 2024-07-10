require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = false,  -- use a classic bottom cmdline for search
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true,      -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,  -- add a border to hover docs and signature help
    },
    notify = {
        -- Noice can be used as `vim.notify` so you can route any notification like other messages
        -- Notification messages have their level and other properties set.
        -- event is always "notify" and kind can be any log level as a string
        -- The default routes will forward notifications to nvim-notify
        -- Benefit of using Noice for this is the routing and consistent history view
        enabled = false,
        view = "notify",
    },
    commands = {
        history = {
            view = "popup",
            opts = { enter = true, format = "details" },
            filter = {
                any = {
                    { event = "notify" },
                    { error = true },
                    { warning = true },
                    { event = "msg_show", kind = { "" } },
                    { event = "lsp",      kind = "message" },
                },
            },
        },
    },
    routes = {
        {
            view = "popup",
            filter = {
                any = {
                    { cmdline = "^:reg" },
                    { cmdline = "^:dis" },
                    { cmdline = "^:ls" },
                    { cmdline = "^:marks" },
                    { cmdline = "^:hi" },
                },
            },
        },
        {
            filter = {
                event = "lsp",
                kind = "progress",
                cond = function(message)
                    local client = vim.tbl_get(message.opts, "progress", "client")
                    return client == "null-ls"
                end,
            },
            opts = { skip = true },
        },
    },
})

vim.keymap.set("n", "<leader>me", "<CMD>Noice telescope<CR>")
