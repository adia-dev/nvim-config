local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion

null_ls.setup({
    sources = {
        formatting.prettier,
        formatting.stylua,
        formatting.zigfmt,
        formatting.swiftformat,
        formatting.swiftlint,
        formatting.mix,

        -- code_actions.cspell,
        code_actions.proselint,
        -- code_actions.gitsigns,
        code_actions.xo,

        completion.luasnip,

        diagnostics.actionlint,
        -- diagnostics.cspell,
        diagnostics.hadolint,
        diagnostics.eslint_d,
        diagnostics.swiftlint,
        diagnostics.credo,
    },
})
