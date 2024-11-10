require("nvim-dap-virtual-text").setup()

local define = vim.fn.sign_define
define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
define("DapStopped", { text = "", texthl = "DiagnosticOk", linehl = "", numhl = "" })
define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

-- DAP and DAP UI setup
local dap, dapui = require("dap"), require("dapui")
dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

dapui.setup({
    controls = {
        element = "repl",
        enabled = true,
    },
    floating = {
        border = "single",
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
    icons = { collapsed = "", expanded = "", current_frame = "" },
    layouts = {
        {
            elements = {
                { id = "stacks",      size = 0.25 },
                { id = "scopes",      size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "watches",     size = 0.25 },
            },
            position = "left",
            size = 60,
        },
        {
            elements = {
                { id = "repl",    size = 1.0 },
                { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 10,
        },
    },
})

-- Automatically open and close DAP UI during debugging sessions
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- --------------------------------------
-- KEYBINDINGS FOR DAP
-- --------------------------------------

-- Basic DAP controls
vim.keymap.set("n", "<leader>dc", "<CMD>Telescope dap commands<CR>")
vim.keymap.set("n", "<leader>ds", dap.step_over)
vim.keymap.set("n", "<leader>di", dap.step_into)
vim.keymap.set("n", "<leader>do", dap.step_out)

-- Breakpoints
vim.keymap.set("n", "<C-b>", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader><C-b>", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)

-- Terminate debug session
vim.keymap.set("n", "<Leader>dx", function()
    dap.terminate()
    dapui.close()
end)

-- --------------------------------------
-- DAP ADAPTERS AND CONFIGURATIONS
-- --------------------------------------

-- Codelldb and LLDB configurations
local codelldb_path = "/Users/adiadev/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/adapter/codelldb"

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = os.getenv("HOME") .. codelldb_path,
        args = {
            "--port",
            "${port}",
            "--liblldb",
            "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB",
        },
    },
}

dap.adapters.lldb = {
    type = 'executable',
    command = '/opt/homebrew/bin/lldb-dap', -- adjust as needed, must be absolute path
    name = 'lldb'
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "lldb",
        request = "launch",
        program = function()
            local pickers = require('telescope.pickers')
            local finders = require('telescope.finders')
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            local conf = require('telescope.config').values

            return coroutine.create(function(coro)
                pickers.new({}, {
                    prompt_title = 'Select Executable',
                    finder = finders.new_oneshot_job(
                        { 'find', vim.fn.getcwd(), '-type', 'f', '-perm', '+111' },
                        { cwd = vim.fn.getcwd() }
                    ),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(prompt_bufnr, map)
                        actions.select_default:replace(function()
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            coroutine.resume(coro, selection.value)
                        end)
                        return true
                    end,
                }):find()
            end)
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
            local args = {}
            print("Enter each argument separately. Press Enter without typing anything to finish.")
            while true do
                local arg = vim.fn.input("Argument: ")
                if arg == "" then
                    break
                end
                table.insert(args, arg)
            end
            return args
        end,
        console = "integratedTerminal", -- Add this line
    },
}



dap.configurations.zig = {
    {
        name = "Launch file",
        type = "lldb",
        request = "launch",
        program = function()
            local pickers = require('telescope.pickers')
            local finders = require('telescope.finders')
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            local conf = require('telescope.config').values

            return coroutine.create(function(coro)
                pickers.new({}, {
                    prompt_title = 'Select Executable',
                    finder = finders.new_oneshot_job(
                        { 'find', vim.fn.getcwd() .. "/zig-out", '-type', 'f', '-perm', '+111' },
                        { cwd = vim.fn.getcwd() }
                    ),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = function(prompt_bufnr, map)
                        actions.select_default:replace(function()
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)
                            coroutine.resume(coro, selection.value)
                        end)
                        return true
                    end,
                }):find()
            end)
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = function()
            local args = {}
            print("Enter each argument separately. Press Enter without typing anything to finish.")
            while true do
                local arg = vim.fn.input("Argument: ")
                if arg == "" then
                    break
                end
                table.insert(args, arg)
            end
            return args
        end,
        console = "integratedTerminal", -- Add this line
    },
}

dap.adapters.coreclr = {
    type = 'executable',
    command = '/usr/local/bin/netcoredbg/netcoredbg',
    args = { '--interpreter=vscode' }
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
    },
}
