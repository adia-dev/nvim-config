require('codesnap').setup({
    save_path = "~/snapshots",
    has_breadcrumbs = true,
    bg_theme = "peach",
    watermark = ""
})

vim.api.nvim_set_keymap('v', '<leader>ts', '<Esc><CMD>CodeSnap<CR>', { noremap = true, silent = true })
