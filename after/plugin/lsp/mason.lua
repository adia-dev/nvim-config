require("mason").setup()
require("mason-lspconfig").setup(
    {
        ensure_installed = {
            "tsserver",
            "html",
            "cssls",
            "tailwindcss",
            "svelte",
            "lua_ls",
            "emmet_ls",
            "clangd",
            "rust_analyzer",
            "pyright",
            "prismals",
        },

        automatic_installation = true
    }
)
