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

require("mason-nvim-dap").setup({
	ensure_installed = { "codelldb" },
	handlers = {},
})

vim.keymap.set("n", "<leader>bp", "<CMD>:DapToggleBreakpoint<CR>", {})
vim.keymap.set("n", "<leader>dc", "<CMD>:DapContinue<CR>", {})
vim.keymap.set("n", "<leader>dsi", "<CMD>:DapStepInto<CR>", {})
vim.keymap.set("n", "<leader>dso", "<CMD>:DapStepOver<CR>", {})
vim.keymap.set("n", "<leader>dsu", "<CMD>:DapStepOut<CR>", {})
vim.keymap.set("n", "<leader>dt", "<CMD>:DapTerminate<CR>", {})
