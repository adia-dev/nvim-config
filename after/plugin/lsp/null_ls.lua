local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local completion = null_ls.builtins.completion

null_ls.setup({
    sources = {
        code_actions.cspell,
        code_actions.gitsigns,
        code_actions.proselint,
        code_actions.xo,

        completion.luasnip,

        -- diagnostics.eslint_d,
        diagnostics.actionlint,
        diagnostics.cppcheck,
        diagnostics.credo,
        diagnostics.cspell,
        diagnostics.hadolint,
        diagnostics.rubocop,
        diagnostics.swiftlint,

        formatting.autoflake,
        formatting.clang_format,
        formatting.erb_format,
        formatting.markdown_toc,
        formatting.mix,
        formatting.prettier,
        formatting.stylua,
        formatting.swiftformat,
        formatting.swiftlint,
        formatting.xmlformat,
        formatting.zigfmt,
    },
    fallback_severity = vim.diagnostic.severity.HINT,
})
