-- DAP Setup
local dap, dapui = require("dap"), require("dapui")
local define = vim.fn.sign_define

-- --------------------------------------
-- Icons for Breakpoints and DAP Events
-- --------------------------------------
require("nvim-dap-virtual-text").setup()
define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })
define("DapStopped", { text = "", texthl = "DiagnosticOk" })
define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })

-- --------------------------------------
-- DAP UI Setup
-- --------------------------------------
dap.defaults.fallback.terminal_win_cmd = "50vsplit new"

dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    layouts = {
        {
            elements = { "console", "repl" }, -- Combine console and REPL for easy access
            size = 0.3, -- Height as percentage of total lines
            position = "bottom",
        },
        {
            elements = { "scopes", "breakpoints", "stacks", "watches" },
            size = 40, -- Width in columns
            position = "left",
        },
    },
    floating = {
        max_height = 0.9,
        max_width = 0.9,
        border = "rounded",
        mappings = { close = { "q", "<Esc>" } },
    },
    render = {
        max_value_lines = 100, -- Limit lines for long variable values
    },
})

-- Open/close DAP UI automatically
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- Restore layout after maximizing a buffer
vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        if vim.bo.filetype == "dap-repl" or vim.bo.filetype == "dapui" then
            dapui.open()
        end
    end,
})

-- --------------------------------------
-- Custom Tabs for DAP UI
-- --------------------------------------
local function toggle_dapui_tabs()
    local tab_exists = vim.fn.tabpagenr("$") > 1
    if tab_exists then
        vim.cmd("tabclose")
    else
        vim.cmd("tabnew | lua require('dapui').open()")
    end
end

vim.keymap.set("n", "<leader>dt", toggle_dapui_tabs, { desc = "Toggle DAP UI in Tabs" })

-- --------------------------------------
-- Keybindings for DAP
-- --------------------------------------
local map = vim.keymap.set
local opts = { silent = true, desc = "DAP" }

-- Debug controls
map("n", "<F5>", dap.continue, { silent = true, desc = "Start/Continue Debugging" })
map("n", "<F10>", dap.step_over, { silent = true, desc = "Step Over" })
map("n", "<F11>", dap.step_into, { silent = true, desc = "Step Into" })
map("n", "<F12>", dap.step_out, { silent = true, desc = "Step Out" })
map("n", "<leader>dx", function()
    dap.terminate()
    dapui.close()
end, { desc = "Terminate Debugging" })

-- Breakpoints
map("n", "<C-b>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader><C-b>", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, { desc = "Set Log Point" })

-- Telescope integrations
map("n", "<leader>dc", "<CMD>Telescope dap commands<CR>", { desc = "Show DAP Commands" })
map("n", "<leader>dB", "<CMD>Telescope dap list_breakpoints<CR>", { desc = "List Breakpoints" })
map("n", "<leader>dv", function() dapui.float_element("scopes") end, { desc = "Show Variable Scopes" })

-- Misc
map("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
map("n", "<leader>dl", dap.run_last, { desc = "Run Last Debugging Session" })

-- --------------------------------------
-- DAP Adapters and Configurations
-- --------------------------------------
local codelldb_path = "/Users/adiadev/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/adapter/codelldb"

-- Adapters
dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = os.getenv("HOME") .. codelldb_path,
        args = { "--port", "${port}", "--liblldb", "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB" },
    },
}
dap.adapters.lldb = { type = "executable", command = "/opt/homebrew/bin/lldb-dap", name = "lldb" }
dap.adapters.coreclr = { type = "executable", command = "/usr/local/bin/netcoredbg/netcoredbg", args = { "--interpreter=vscode" } }

-- Filtering of the bin selection in Telescope
local function filter_bin(entry)
    local relative = entry:match(".*/(bin/.*)")
    if relative then
        return { value = vim.fn.getcwd() .. "/" .. relative, display = relative, ordinal = relative }
    end
    return nil
end

-- Helper for program selection in Telescope
local function select_program(bin_filter, filter_function)
    return coroutine.create(function(coro)
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        pickers.new({}, {
            prompt_title = "Select Executable",
            finder = finders.new_oneshot_job(
                { "find", vim.fn.getcwd(), "-type", "f", "-name", bin_filter },
                {
                    cwd = vim.fn.getcwd(),
                    entry_maker = function(entry)
                        if filter_function then
                            local filtered = filter_function(entry)
                            if not filtered then
                                return nil -- Skip if filtering returns nil
                            end
                            return filtered
                        end
                        -- Default entry maker if no filter is applied
                        return { value = entry, display = entry, ordinal = entry }
                    end,
                }
            ),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    coroutine.resume(coro, selection.value)
                end)
                return true
            end,
        }):find()
    end)
end

-- Configurations
dap.configurations.cpp = {
    {
        name = "Launch C++ File",
        type = "lldb",
        request = "launch",
        program = function() return select_program("*") end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        console = "integratedTerminal",
    },
}

dap.configurations.zig = {
    {
        name = "Launch Zig File",
        type = "lldb",
        request = "launch",
        program = function() return select_program("zig-out/*") end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        console = "integratedTerminal",
    },
}

dap.configurations.cs = {
    {
        name = "Launch .NET Core",
        type = "coreclr",
        request = "launch",
        program = function() return select_program("*.dll", filter_bin) end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        console = "integratedTerminal",
    },
}
