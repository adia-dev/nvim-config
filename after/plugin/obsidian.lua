require("obsidian").setup({
    workspaces = {
        {
            name = "personal",
            path = "~/vaults/projects",
        },
        {
            name = "school",
            path = "~/vaults/school",
        },
        {
            name = "work",
            path = "~/vaults/work",
        },
        {
            name = "iCloud",
            path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents",
        },
    },
    daily_notes = {
        folder = "Dailies",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = nil,
    },
    completion = {
        nvim_cmp = true,
        min_chars = 1,
    },
    new_notes_location = "notes_subdir",
    -- Optional, customize how note IDs are generated given an optional title.
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
        if title ~= nil then
            return title
        else
            local suffix = ""
            for _ = 1, 4 do
                suffix = suffix .. string.char(math.random(65, 90))
            end
            return tostring(os.time()) .. "-" .. suffix
        end
    end,

    -- Optional, customize how note file names are generated given the ID, target directory, and title.
    ---@param spec { id: string, dir: obsidian.Path, title: string|? }
    ---@return string|obsidian.Path The full path to the new note.
    note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
    end,
})
