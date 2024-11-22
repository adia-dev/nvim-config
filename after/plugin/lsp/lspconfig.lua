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
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Enable completion triggered by <c-x><c-o>
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }


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

        vim.keymap.set("n", "K", "<CMD>Lspsaga hover_doc<CR>", { desc = "Hover documentation" })

        -- setup compiler config for omnisharp
        -- if client and (client.name == "omnisharp" or client.name == "csharp_ls") then
            vim.keymap.set('n', 'gd', require('omnisharp_extended').lsp_definition, { desc = '[G]oto [D]efinition' })
            vim.keymap.set('n', 'gr', require('omnisharp_extended').lsp_references, { desc = '[G]oto [R]eferences' })
            vim.keymap.set('n', 'gI', require('omnisharp_extended').lsp_implementation,
                { desc = '[G]oto [I]mplementation' })
            vim.keymap.set('n', '<leader>D', require('omnisharp_extended').lsp_type_definition,
                { desc = 'Type [D]efinition' })
        -- else
        --     -- Code navigation and info
        --     vim.keymap.set("n", "gr", "<CMD>Lspsaga finder<CR>", opts) -- Lists references and definitions
        --     vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
        --     vim.keymap.set("n", "gd", "<CMD>Lspsaga goto_definition<CR>", { desc = "Go to definition" })
        --     vim.keymap.set("n", "gi", "<CMD>Telescope lsp_implementations<CR>", { desc = "List implementations" })
        -- end
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
    cmd = { "/usr/bin/clangd" },
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
-- lspconfig.docker_compose_language_service.setup({
--     capabilities = capabilities,
-- })
-- lspconfig.ruby_ls.setup({
--     capabilities = capabilities,
-- })
lspconfig.elixirls.setup({
    cmd = { "elixir-ls" },
    capabilities = capabilities,
})
-- lspconfig.dockerls.setup({
--     capabilities = capabilities,
-- })
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

require("telescope").load_extension("csharpls_definition")

-- lspconfig.csharp_ls.setup({
--     capabilities = capabilities,
-- })

local omnisharp_bin = "/usr/local/bin/omnisharp-roslyn/Omnisharp.dll"

lspconfig.omnisharp.setup {
    cmd = { "/Users/ab.dia/devtools/dotnet/dotnet", omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) },
    handlers = {
        ["textDocument/definition"] = require("omnisharp_extended").handler,
    },
    capabilities = capabilities,
    settings = {
        FormattingOptions = {
            -- Enables support for reading code style, naming convention and analyzer
            -- settings from .editorconfig.
            EnableEditorConfigSupport = true,
            -- Specifies whether 'using' directives should be grouped and sorted during
            -- document formatting.
            OrganizeImports = true,
        },
        MsBuild = {
            -- If true, MSBuild project system will only load projects for files that
            -- were opened in the editor. This setting is useful for big C# codebases
            -- and allows for faster initialization of code navigation features only
            -- for projects that are relevant to code that is being edited. With this
            -- setting enabled OmniSharp may load fewer projects and may thus display
            -- incomplete reference lists for symbols.
            LoadProjectsOnDemand = true,
        },
        RoslynExtensionsOptions = {
            -- Enables support for roslyn analyzers, code fixes and rulesets.
            EnableAnalyzersSupport = true,
            -- Enables support for showing unimported types and unimported extension
            -- methods in completion lists. When committed, the appropriate using
            -- directive will be added at the top of the current file. This option can
            -- have a negative impact on initial completion responsiveness,
            -- particularly for the first few completion sessions after opening a
            -- solution.
            EnableImportCompletion = true,
            -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
            -- true
            AnalyzeOpenDocumentsOnly = nil,
        },
        Sdk = {
            -- Specifies whether to include preview versions of the .NET SDK when
            -- determining which version to use for project loading.
            IncludePrereleases = true,
        },
    },
}


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
