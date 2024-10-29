require("which-key").setup({
    plugins = {
        marks = true,     -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in normal or <C-r> in insert mode
        spelling = {
            enabled = true,
            suggestions = 20,
        },
    },
    key_labels = {
        ["<leader>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
    },
    window = {
        border = "single",   -- none, single, double, shadow
        position = "top", -- bottom, top
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3,                    -- spacing between columns
    },
})

vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end)
