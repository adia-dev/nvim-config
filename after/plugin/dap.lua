require("nvim-dap-virtual-text").setup()

local dap, dapui = require("dap"), require("dapui")
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

vim.keymap.set("n", "<leader>bp", "<CMD>:DapToggleBreakpoint<CR>", {})
vim.keymap.set("n", "<leader>dc", "<CMD>:DapContinue<CR>", {})
vim.keymap.set("n", "<leader>dsi", "<CMD>:DapStepInto<CR>", {})
vim.keymap.set("n", "<leader>dso", "<CMD>:DapStepOver<CR>", {})
vim.keymap.set("n", "<leader>dsu", "<CMD>:DapStepOut<CR>", {})
vim.keymap.set("n", "<leader>dt", "<CMD>:DapTerminate<CR>", {})

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "/Users/adiadev/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/adapter/codelldb",
		args = { "--port", "${port}" },
	},
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
