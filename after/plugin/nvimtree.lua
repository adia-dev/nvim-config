vim.opt.termguicolors = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function custom_keybindings(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    vim.keymap.set("n", "<leader>r", api.tree.reload, opts("Reload Tree"))
    vim.keymap.set("n", "<leader>n", api.node.open.edit, opts("Edit File"))
    vim.keymap.set("n", "<leader>R", api.tree.change_root_to_node, opts("Change Root"))
    vim.keymap.set("n", "<leader>T", api.tree.change_root_to_parent, opts("Up"))
    vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
end

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        width = 40,
    },
    renderer = {
        highlight_opened_files = "icon",
        root_folder_modifier = ":~",
        group_empty = true,
        icons = {
            show = { file = true, folder = true, git = true, folder_arrow = true },
            glyphs = {
                default = "",
                symlink = "",
                git = {
                    unstaged = "●",
                    staged = "✓",
                    unmerged = "",
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
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    filters = {
        dotfiles = false,
        custom = { "node_modules", "__pycache__" },
    },
    on_attach = custom_keybindings,
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})

-- Open NvimTree or focus on it if already open
vim.keymap.set("n", "<leader>e", "<CMD>NvimTreeFindFileToggle<CR>", { desc = "Toggle File Tree" })

-- Reveal current file in the NvimTree
vim.keymap.set("n", "<leader>E", "<CMD>NvimTreeFindFile<CR>", { desc = "Find File in Tree" })

vim.cmd([[
    :hi      NvimTreeExecFile    guifg=#ffa0a0
    :hi      NvimTreeSpecialFile guifg=#ff80ff gui=underline
    :hi      NvimTreeSymlink     guifg=Yellow  gui=italic
    :hi link NvimTreeImageFile   Title
]])
