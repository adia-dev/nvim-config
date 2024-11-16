require("nvim-web-devicons").setup({
    override = {
        zsh = { icon = "", color = "#428850", name = "Zsh" },
        lua = { icon = "", color = "#51a0cf", name = "Lua" },
    },
    override_by_filename = {
        [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore"
        }
    },
    -- same as `override` but specifically for overrides by extension
    -- takes effect when `strict` is true
    override_by_extension = {
        ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log"
        }
    },
    default = true, -- Enable default icons
})
