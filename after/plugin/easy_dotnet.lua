require("easy-dotnet").setup({
    terminal = function(path, action)
        local commands = {
            run = function()
                return "dotnet run --project " .. path
            end,
            test = function()
                return "dotnet test " .. path
            end,
            restore = function()
                return "dotnet restore " .. path
            end,
            build = function()
                return "dotnet build " .. path
            end,
        }

        local command = commands[action]()
        print("Executing: " .. command)

        -- Reuse or create a terminal buffer
        local term_buf = vim.fn.bufnr("easy-dotnet-term", true)
        if term_buf == -1 then
            -- Create a new terminal buffer if none exists
            vim.cmd("vsplit | terminal")
            term_buf = vim.fn.bufnr("%")
            vim.api.nvim_buf_set_name(term_buf, "easy-dotnet-term")
        else
            -- Switch to the terminal buffer
            vim.cmd("buffer " .. term_buf)
        end

        -- Send the command to the terminal
        vim.fn.chansend(vim.b.terminal_job_id, command .. "\n")
    end,
})

-- Toggle Terminal
vim.keymap.set("n", "<leader>tt", function()
    local term_buf = vim.fn.bufnr("easy-dotnet-term", true)
    if term_buf ~= -1 then
        local win_id = vim.fn.bufwinnr(term_buf)
        if win_id ~= -1 then
            vim.cmd("hide")
        else
            vim.cmd("buffer " .. term_buf)
        end
    else
        vim.cmd("vsplit | terminal")
        vim.api.nvim_buf_set_name(0, "easy-dotnet-term")
    end
end, { desc = "Toggle Terminal" })
