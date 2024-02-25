require("nvim-dap-virtual-text").setup()

local define = vim.fn.sign_define
define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
define("DapStopped", { text = "", texthl = "DiagnosticOk", linehl = "", numhl = "" })
define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
define("DapLogPoint", { text = "", texthl = "DiagnosticInfo", linehl = "", numhl = "" })

local dap, dapui = require("dap"), require("dapui")
local xcodebuild = require("xcodebuild.dap")
dapui.setup({
    {
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
                    { id = "repl", size = 1.0 },
                    -- { id = "console", size = 0.5 },
                },
                position = "bottom",
                size = 10,
            },
        },
    },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- integration with xcodebuild.nvim
vim.keymap.set("n", "<leader>dd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
vim.keymap.set("n", "<leader>dr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })

vim.keymap.set("n", "<leader>dc", dap.continue)
vim.keymap.set("n", "<leader>ds", dap.step_over)
vim.keymap.set("n", "<leader>di", dap.step_into)
vim.keymap.set("n", "<leader>do", dap.step_out)
vim.keymap.set("n", "<C-b>", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader><C-b>", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
vim.keymap.set("n", "<Leader>dx", function()
    dap.terminate()
    require("xcodebuild.actions").cancel()

    dapui.close()
end)

local codelldb = "/Users/adiadev/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/adapter/codelldb"

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
    },
}

dap.configurations.swift = {
    {
        name = "iOS App Debugger",
        type = "codelldb",
        request = "attach",
        program = xcodebuild.get_program_path,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        waitFor = true,
    },
}

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = os.getenv("HOME") .. codelldb,
        args = {
            "--port",
            "${port}",
            "--liblldb",
            "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB",
        },
    },
}
