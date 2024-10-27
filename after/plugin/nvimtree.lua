-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwPlugin = 1

local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
    vim.keymap.set("n", "<C-u>", api.tree.change_root_to_node, opts("CD"))
    vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

-- OR setup with some options
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
        preserve_window_proportions = true,
    },
    renderer = {
        group_empty = false,
        icons = {
            glyphs = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "CONFLICT ",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
                folder = {
                    arrow_open = "",
                    arrow_closed = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
            },
        },
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    filters = {
        dotfiles = true,
    },
    on_attach = my_on_attach,
})

vim.keymap.set("n", "<leader>e", "<CMD>NvimTreeFindFileToggle<CR>")
vim.keymap.set("n", "<leader>E", "<CMD>NvimTreeFindFile<CR>")
