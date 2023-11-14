-- For lsp file operations like
-- renaming an import and the file gets updated
-- or vice-versa...
require("lsp-file-operations").setup()

-- Setup language servers.
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>ww', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>K', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>J', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gR', "<CMD>Telescope lsp_references<CR>", opts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', "<CMD>Telescope lsp_definitions<CR>", opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', "<CMD>Telescope lsp_implementations<CR>", opts)
        vim.keymap.set('n', 'gt', "<CMD>Telescope lsp_type_definitions<CR>", opts)
        vim.keymap.set('n', '<leader>k', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>rs', ":LspRestart<CR>", opts)
        vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workleader_folders()))
        end, opts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>fl', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.pyright.setup {
    capabilities = capabilities
}
lspconfig.tsserver.setup {
    capabilities = capabilities
}
lspconfig.lua_ls.setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            },
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
}
lspconfig.clangd.setup {
    capabilities = capabilities
}
lspconfig.zls.setup {
    capabilities = capabilities
}
lspconfig.emmet_ls.setup {
    capabilities = capabilities
}

capabilities.textDocument.completion.completionItem.snippetSupport = true
local cssls_capabilities = vim.lsp.protocol.make_client_capabilities()

lspconfig.cssls.setup {
    capabilities = cssls_capabilities
}
lspconfig.rust_analyzer.setup {
    -- Server-specific settings. See `:help lspconfig-setup`
    capabilities = capabilities,
    settings = {
        ['rust-analyzer'] = {},
    },
}
