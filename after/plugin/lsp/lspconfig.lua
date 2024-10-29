-- For lsp file operations like
-- renaming an import and the file gets updated
-- or vice-versa...
require("lsp-file-operations").setup()
local pid = vim.fn.getpid()

-- Setup language servers.
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set("n", "<leader>ww", "<CMD>Lspsaga show_workspace_diagnostics ++normal<CR>")
-- Diagnostics navigation
vim.keymap.set("n", "<leader>K", "<CMD>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>J", "<CMD>Lspsaga diagnostic_jump_next<CR>", { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local bufnr = ev.buf

        -- Enable completion triggered by <c-x><c-o>
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }

        -- Code navigation and info
        vim.keymap.set("n", "gr", "<CMD>Lspsaga finder<CR>", opts) -- Lists references and definitions
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
        vim.keymap.set("n", "gd", "<CMD>Lspsaga goto_definition<CR>", { desc = "Go to definition" })
        vim.keymap.set("n", "K", "<CMD>Lspsaga hover_doc<CR>", { desc = "Hover documentation" })
        vim.keymap.set("n", "gi", "<CMD>Telescope lsp_implementations<CR>", { desc = "List implementations" })

        -- Diagnostics and outline
        vim.keymap.set("n", "<leader>gk", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Open diagnostic float" })
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "Signature help" })

        -- Workspace management
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
        vim.keymap.set("n", "<leader>wo", "<CMD>:Lspsaga outline<CR>", { desc = "Toggle outline" })
        vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { desc = "List workspace folders" })

        -- Type definitions and renaming
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
        vim.keymap.set("n", "<leader>rn", "<CMD>Lspsaga rename<CR>", { desc = "Rename symbol" })

        -- Code actions
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
        vim.keymap.set("n", "<leader>fl", function()
            vim.lsp.buf.format({ async = true })
        end, { desc = "Format document" })

        -- Custom LSP commands
        vim.keymap.set("n", "<leader>oi", "<CMD>OrganizeImports<CR>", { desc = "Organize imports" })
        vim.keymap.set("n", "<leader>rs", "<CMD>LspRestart<CR>", { desc = "Restart LSP" })
    end,
})

local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.pyright.setup({
    capabilities = capabilities,
})

local function organize_imports()
    local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = "",
    }
    vim.lsp.buf.execute_command(params)
end

lspconfig.ts_ls.setup({
    capabilities = capabilities,
    commands = {
        OrganizeImports = {
            organize_imports,
            description = "Organize Imports",
        },
    },
})
lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            },
        },
    },
})
lspconfig.clangd.setup({
    capabilities = capabilities,
})
lspconfig.html.setup({
    capabilities = capabilities,
})
lspconfig.zls.setup({
    -- cmd = {"/Users/adiadev/repos/zig-lsp-sample/zig-out/bin/zig-lsp-sample"},
    capabilities = capabilities,
})
lspconfig.emmet_ls.setup({
    capabilities = capabilities,
})
lspconfig.tailwindcss.setup({
    capabilities = capabilities,
})
lspconfig.cmake.setup({
    capabilities = capabilities,
})
lspconfig.docker_compose_language_service.setup({
    capabilities = capabilities,
})
-- lspconfig.ruby_ls.setup({
--     capabilities = capabilities,
-- })
lspconfig.elixirls.setup({
    cmd = { "elixir-ls" },
    capabilities = capabilities,
})
lspconfig.dockerls.setup({
    capabilities = capabilities,
})
lspconfig.glsl_analyzer.setup({
    capabilities = capabilities,
})
lspconfig.prismals.setup({
    capabilities = capabilities,
})
lspconfig.taplo.setup({
    capabilities = capabilities,
})
lspconfig.gopls.setup({
    capabilities = capabilities,
})
lspconfig.dartls.setup({
    capabilities = capabilities,
})
lspconfig.kotlin_language_server.setup({
    capabilities = capabilities,
    storagePath = "/Users/adiadev/repos/kotlin-language-server/storage",
})

lspconfig.jdtls.setup({
    capabilities = capabilities,
})

capabilities.textDocument.completion.completionItem.snippetSupport = true
local cssls_capabilities = vim.lsp.protocol.make_client_capabilities()

lspconfig.cssls.setup({
    capabilities = cssls_capabilities,
})

lspconfig.rust_analyzer.setup({
    cmd = vim.lsp.rpc.connect("127.0.0.1", 27631),
    -- When using unix domain sockets, use something like:
    --cmd = vim.lsp.rpc.domain_socket_connect("/path/to/ra-multiplex.sock"),
    capabilities = capabilities,
    init_options = {
        lspMux = {
            version = "1",
            method = "connect",
            server = "rust-analyzer",
        },
    },
})

-- lspconfig.rust_analyzer.setup({
--     cmd = { "ra-multiplex" },
--     -- Server-specific settings. See `:help lspconfig-setup`
--     capabilities = capabilities,
--     settings = {
--         ["rust-analyzer"] = {
--             diagnostic = {
--                 enable = true,
--             },
--         },
--     },
-- })

local omnisharp_bin = "/usr/local/bin/omnisharp-roslyn/Omnisharp.dll"
lspconfig.omnisharp.setup({
    cmd = { "dotnet", omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
    ["textDocument/definition"] = require("omnisharp_extended").handler,
    capabilities = capabilities,
    enable_editorconfig_support = true,
    enable_ms_build_load_projects_on_demand = false,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    sdk_include_prereleases = true,
    analyze_open_documents_only = true,
})

lspconfig["sourcekit"].setup({
    filetypes = { "swift" },
    capabilities = capabilities,
    cmd = { "xcrun", "sourcekit-lsp" },
    root_dir = function(filename, _)
        return util.root_pattern("buildServer.json")(filename)
            or util.root_pattern("*.xcodeproj", "*.xcworkspace")(filename)
            or util.find_git_ancestor(filename)
            or util.root_pattern("Package.swift")(filename)
    end,
})
